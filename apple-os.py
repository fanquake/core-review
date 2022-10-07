#!/usr/bin/env python3

# pip install beautifulsoup4 GitPython requests
# python3 apple_os.py dyld -g
# TODO:
# Fix perms issues with some repositories (cctools)

import argparse
import os
import re
import requests
import shutil
import sys
import tarfile

from bs4 import BeautifulSoup
from git import Repo
from typing import List

def filename(lib: str, version: str) -> str:
	return '{}-{}.tar.gz'.format(lib, version)

def download(lib: str, filename: str):
	url = 'https://opensource.apple.com/tarballs/{}/{}'.format(lib, filename)
	r = requests.get(url)
	with open(filename, 'wb') as f:
		f.write(r.content)

def empty_repo(directory: str):
	os.makedirs(directory)
	repo = Repo.init(directory)
	with open(directory + '/.gitignore', 'w') as f:
		f.write('*.tar.gz\n')
	repo.index.add(['.gitignore'])
	repo.index.commit("Initial Commit")

def build_git(library: str, versions: List[str]):

	directory = 'repos/{}'.format(library)

	if not os.path.exists(directory):
		empty_repo(directory)

	repo = Repo(directory)

	for version in versions:
		print(version)

		f = filename(library, version)
		download(library, f)

		with tarfile.open(f, 'r') as tar:
def is_within_directory(directory, target):
	
	abs_directory = os.path.abspath(directory)
	abs_target = os.path.abspath(target)

	prefix = os.path.commonprefix([abs_directory, abs_target])
	
	return prefix == abs_directory

def safe_extract(tar, path=".", members=None, *, numeric_owner=False):

	for member in tar.getmembers():
		member_path = os.path.join(path, member.name)
		if not is_within_directory(path, member_path):
			raise Exception("Attempted Path Traversal in Tar File")

	tar.extractall(path, members, numeric_owner=numeric_owner) 
	

safe_extract(tar, "repos/", numeric_owner="True")
		os.remove(f)
		untar = 'repos/{}-{}/'.format(library, version)

		shutil.copytree(untar, directory, dirs_exist_ok=True, symlinks=False)
		shutil.rmtree(untar)

		[repo.index.add([f]) for f in os.listdir(directory) if not f.startswith('.')]
		repo.index.commit("{} - {}".format(library, version))

parser = argparse.ArgumentParser(description='Apple Open Source Libraries')
parser.add_argument('library', type=str, help='Library to search for')
parser.add_argument('-download', metavar='d', const=True, nargs='?', help='Download latest tarball')
parser.add_argument('-git', metavar='g', const=True, nargs='?', help='Build git history')
args = parser.parse_args()

regex = re.compile('{}-'.format(args.library))

request = requests.get('https://opensource.apple.com/tarballs/{}'.format(args.library))
if request.status_code != 200:
	print('Failed to find library: {}'.format(args.library))
	sys.exit(1)

soup = BeautifulSoup(request.text, 'html.parser')

versions= set()
for link in soup.find_all('a'):
	ref = link.get('href')
	if regex.match(ref):
		stripped = ref.split('-')[1].rstrip('.tar.gz')
		versions.add(stripped)

versions = list(versions)
versions.sort(key=lambda version:[int(v) for v in version.split('.')])

if args.download:
	f = filename(args.library, versions[len(versions)-1])
	download(args.library, f)

if args.git:
	build_git(args.library, versions)

info = """Releases: {}
Oldest: {}
Newest: {}""".format(len(versions),versions[0], versions[len(versions)-1])
print(info)

