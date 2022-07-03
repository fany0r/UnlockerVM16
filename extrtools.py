#!/usr/bin/env python
"""
The MIT License (MIT)

Copyright (c) 2015-2017 Dave Parsons

"""

from __future__ import print_function
import os
import sys
import shutil
import tarfile
import zipfile
import time


def convertpath(path):
    # OS path separator replacement funciton
    return path.replace(os.path.sep, '/')

def main():
	# Check minimal Python version is 2.7
	if sys.version_info < (3, 0):
		sys.stderr.write('[!] You need Python 3 or later\n')
		sys.exit(1)

	dest = os.path.dirname(os.path.abspath(__file__))
	
	print('[+] Extracting com.vmware.fusion.zip.tar...')
	tar = tarfile.open(convertpath(dest + '/tools/com.vmware.fusion.zip.tar'), 'r')
	tar.extract('com.vmware.fusion.zip', path=convertpath(dest + '/tools/'))
	tar.close()
	
	print('[+] Extracting files from com.vmware.fusion.zip...')
	cdszip = zipfile.ZipFile(convertpath(dest + '/tools/com.vmware.fusion.zip'), 'r')
	cdszip.extract('payload/VMware Fusion.app/Contents/Library/isoimages/darwin.iso', path=convertpath(dest + '/tools/'))
	cdszip.extract('payload/VMware Fusion.app/Contents/Library/isoimages/darwinPre15.iso', path=convertpath(dest + '/tools/'))
	cdszip.close()
	
	# Move the iso and sig files to tools folder
	shutil.move(convertpath(dest + '/tools/payload/VMware Fusion.app/Contents/Library/isoimages/darwin.iso'), convertpath(dest + '/tools/darwin.iso'))
	shutil.move(convertpath(dest + '/tools/payload/VMware Fusion.app/Contents/Library/isoimages/darwinPre15.iso'), convertpath(dest + '/tools/darwinPre15.iso'))
	
	# Cleanup working files and folders
	shutil.rmtree(convertpath(dest + '/tools/payload'), True)
	# os.remove(convertpath(dest + '/tools/com.vmware.fusion.zip.tar'))
	os.remove(convertpath(dest + '/tools/com.vmware.fusion.zip'))
	
	print('[+] Tools retrieved successfully')
	return


if __name__ == '__main__':
    main()
