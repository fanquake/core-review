#!/usr/bin/env python3
# similar to contrib/devtools/symbol-check.py
# python3 macos_dylib_check.py src/qt/bitcoin-qt

import subprocess
import sys
import os
from typing import List

OTOOL_CMD = os.getenv('OTOOL', '/usr/bin/otool')

ALLOWED_LIBRARIES = {
	'AppKit', # user interface
	'ApplicationServices', # common application tasks.
	'Carbon', # deprecated c back-compat API
	'CoreFoundation', # low level func, data types
	'CoreGraphics', # 2D rendering
	'CoreServices', # operating system services
	'CoreText', # interface for laying out text and handling fonts.
	'Foundation', # base layer functionality for apps/frameworks
	'ImageIO', # read and write image file formats.
	'IOKit', # user-space access to hardware devices and drivers.
	'libc++.1.dylib', # C++ Standard Library
	'libobjc.A.dylib', # Objective-C runtime library
	'libSystem.B.dylib', # libc, libm, libpthread, libinfo
}

ALLOWED_DYLOAD_FLAGS = {
	'ALL', # cpu subtype
	'BINDS_TO_WEAK', # linked image uses weak symbols
	'DYLDLINK', # object file cannot be statically link edited again
	'EXECUTE', # demand paged executable file
	'LIB64', # caps
	'MH_HAS_TLV_DESCRIPTORS', # contains a section of type S_THREAD_LOCAL_VARIABLES
	'MH_MAGIC_64', # 64-bit mach magic number
	'NOUNDEFS', # Object file has no undefined references
	'PIE', # Position Independant Executable
	'TWOLEVEL', # using two-level name space bindings
	'WEAK_DEFINES', # final linked image contains external weak symbols
	'X86_64', # cputype
}

def run_cmd(cmd):
	p = subprocess.Popen(cmd, stdout=subprocess.PIPE, 
		stderr=subprocess.PIPE, stdin=subprocess.PIPE, universal_newlines=True)
	(stdout, stderr) = p.communicate()
	if p.returncode:
		raise IOError('Error opening {}', filename)
	return stdout

def read_flags(filename) -> List[str]:
	stdout = run_cmd([OTOOL_CMD, '-vh', filename])
	flags = []
	for line in stdout.splitlines():
		tokens = line.split()
		# filter first two header lines
		if 'magic' in tokens or 'Mach' in tokens: continue
		# filter ncmds and sizeofcmds values
		flags = flags + [t for t in tokens if not t.isdigit()]
	return flags

def read_libraries(filename) -> List[str]:
	stdout = run_cmd([OTOOL_CMD, '-L', filename])
	libraries = []
	for line in stdout.splitlines():
		tokens = line.split()
		# skip line with executable name
		if len(tokens) == 1: continue
		libraries.append(tokens[0].split('/')[-1])
	return libraries

if __name__ == '__main__':
	retval = 0
	for dylib in read_libraries(sys.argv[1]):
		if dylib not in ALLOWED_LIBRARIES:
			print('{} is not in ALLOWED_LIBRARIES!'.format(dylib))
			retval = 1
	for flag in read_flags(sys.argv[1]):
		if flag not in ALLOWED_DYLOAD_FLAGS:
			print('{} is not in ALLOWED_DYLOAD_FLAGS!'.format(flag))
			retval = 1
	sys.exit(retval)