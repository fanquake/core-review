import collections
import os
import re
import subprocess
import sys

# Calculate _chk % replacement when using FORTIFY_SOURCE
# https://developers.redhat.com/blog/2020/02/11/toward-_fortify_source-parity-between-clang-and-gcc/

OBJDUMP_CMD = os.getenv('OBJDUMP', '/usr/bin/objdump')
filename = sys.argv[1]

def objdump(args):
    p = subprocess.Popen([OBJDUMP_CMD, args, filename], stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE, universal_newlines=True)
    (stdout, stderr) = p.communicate()
    if p.returncode:
        print(stderr)
        exit(0)
    return stdout

# Check the dynamic symbol table for _chk variants
dy_syms = []

for line in objdump('-T').splitlines():
    match = re.search(r'__[a-z]*_chk', line)
    if match:
        # we'll account for stack_chk_fail separately 
        if '__stack_chk' in match.group(0):
            continue
        dy_syms.append(match.group(0))

# disassemble and count _chk and non _chk variants
counts = collections.Counter()
stack_chk_fail = 0

for line in objdump('-d').splitlines():
    
    _chk = [sym for sym in dy_syms if (sym+'@plt' in line )]
    if _chk:
        counts[_chk[0]] += 1

    non_chk = [sym.strip('_chk') for sym in dy_syms if ('<' + sym.strip('_chk') + '@plt' in line)]
    if non_chk:
        counts[non_chk[0]] += 1

    if '__stack_chk_fail' in line:
        stack_chk_fail += 1

result = []

for sym in dy_syms:
    plain = sym.strip('_chk')

    # drop one for .plt
    plain_count = (counts[plain] - 1) if counts[plain] > 0 else 0
    chk_count = counts[sym] - 1
    replaced = round((chk_count / (plain_count + chk_count) * 100),2)

    result.append((plain, plain_count, chk_count, replaced))
    result.sort(key=lambda t: t[0])

print('{:10}| {:7} | {:4} | {:10} |'.format('Symbol', 'non _chk', '_chk', '% replaced'))
print('\n'.join('{:10}: {:8} | {:4} | {:9}% |'.format(a,b,c,d) for (a,b,c,d) in result))
print()
print('{} calls to __stack_chk_fail()'.format(stack_chk_fail))
