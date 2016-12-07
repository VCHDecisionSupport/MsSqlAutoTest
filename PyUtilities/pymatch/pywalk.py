from time import gmtime, strftime
import os
from os.path import join, getsize
import hashlib
import time
import sys
from time import clock
import datetime
try:
	from lxml import etree
except Exception as e:
	print('please install lxml python package')

class DirWalker(object):
	"""docstring for DirWalker"""
	root_dir = ''
	def __init__(self, root_dir):
		super(DirWalker, self).__init__()
		self.root_dir = root_dir
		self.xmlroot = etree.Element("root",path=self.root_dir)
		self.dircount = 1
		self.filecount = 0

	# def foo(self, parent=None, level=0):
	# 	if parent == None:
	# 		parent = self.xmlroot
	# 	print(parent.tag)
	# 	print(parent.get("path"))
	# 	print(parent)
	# 	for entry in os.scandir(parent.get("path")):
	# 		print(entry)
	# 		if entry.is_symlink():
	# 			print('type: symlink; path: {}'.format(parent.get("path")))
	# 			parent.append(etree.Element("symlink", path=parent.get("path"), name=entry.name))
	# 		elif entry.is_file():
	# 			print('type: file; path: {}'.format(parent.get("path")))
	# 			parent.append(etree.Element("file", path=parent.get("path"), name=entry.name))
	# 		elif entry.is_dir():
	# 			print('type: dir; path: {}'.format(parent.get("path")))
	# 			parent.append(etree.Element("dir", path=parent.get("path"), name=entry.name)) 
	# 	# print(parent)
		
	def find_the_mutants(self):
		x = ''
		smaller = lambda a,b: a if a < b else b
		for root, dirs, files in os.walk(self.root_dir):
			x = os.path.join(x,root)
			if self.filecount > 1000000:
				# break
				pass
			try:
				for file in files:
					fpath = os.path.join(x,file)
					if not os.path.isfile(fpath):
						# print('{} is not valid file'.format(fpath))
						# f.write('{} is not valid file'.format(fpath))
						pass
					else:
						self.filecount += 1
						try:
							print('{} files in {}'.format(self.filecount, self.dircount))
						except Exception as e:
							print(e)
						try:
							BLOCKSIZE = 65536
							hasher = hashlib.sha1()
							with open(fpath, 'rb') as afile:
								buf = afile.read(BLOCKSIZE)
								while len(buf) > 0:
									hasher.update(buf)
									buf = afile.read(BLOCKSIZE)
						except Exception as e:
							print(e)
							print('unable to hash file')
						try:
							fsize = getsize(fpath)
							(mode, ino, dev, nlink, uid, gid, size, atime, mtime, ctime) = os.stat(fpath)
							#,mode=mode, ino=ino, dev=dev, nlink=nlink, uid=uid, gid=gid, size=size, atime=atime, mtime=mtime, filesize=fsize)
							# atime='{}'.format(time.ctime(st_atime), mtime='{}'.format(time.ctime(st_mtime), ctime='{}'.format(time.ctime(st_ctime)
							# self.xmlroot.append(etree.Element("file", fullpath=fpath, name=file, parent=root, index=os.path.join(os.path.split(root)[1],file), hash=hasher.hexdigest(), filesize=str(fsize)), atime='{}'.format(time.ctime(st_atime)), mtime='{}'.format(time.ctime(st_mtime)), ctime='{}'.format(time.ctime(st_ctime)))
						except Exception as e:
							print(e)
							print('unable to get file meta data')
						try:
							self.xmlroot.append(etree.Element("file", fullpath=fpath, name=file, parent=root, index=os.path.join(os.path.split(root)[1],file), hash=hasher.hexdigest(), filesize=str(fsize), atime='{}'.format(strftime("%Y-%m-%d",time.gmtime(atime))), mtime='{}'.format(strftime("%Y-%m-%d",time.gmtime(mtime))), ctime='{}'.format(strftime("%Y-%m-%d",time.gmtime(ctime)))))
						except Exception as e:
							print(e)
							print('unable to save file info')
						if self.filecount > 1000:
							# break
							pass
			except IOError as e:
				print(e)
				print('unhandled IOError mapping directory files')
			try:
				if not os.path.isdir(x):
					print('{} is not valid'.format(x))
					# f.write('{} is not valid'.format(x))
					pass
				else:
					self.dircount += 1
					print('{} files in {}'.format(self.filecount, self.dircount))
					# print('{} files in {} dirs dir path: {} ... {}'.format(self.filecount, self.dircount, x[0:smaller(len(x),60)], x[-60:len(x)]))
			except Exception as e:
				print(e)
				print('unhandled error looping of folders')

if __name__ == '__main__':
	start = clock()
	good = r'\\GWAIIHAANAS\CPAWS Shared Files'
	bad = r'\\GWAIIHAANAS\d'
	scriptname = os.path.split(sys.argv[0])[1]
	print('usage: place {} in folder you want to map then run it.'.format(scriptname))
	try:
		# print(sys.argv)
		# print(os.getcwd())
		cwd = os.getcwd()
	except Exception as e:
		print(e)
		cwd = bad
	try:
		input('press enter to map: {}'.format(cwd))
		dw = DirWalker(cwd)
		dw.find_the_mutants()
		print('mapping complete saving to xml . . .')
	except Exception as e:
		print(e)
		print('FATAL ERROR: do not pass go do not collect $100')
	try:
		# print(os.path.split(os.path.split(cwd)[0])[1])
		ofile = '{} {}.xml'.format(os.path.split(os.path.split(cwd)[0])[1], datetime.date.today().isoformat())
		if os.path.isfile(ofile):
			ofile = 'whereswaldo {}.xml'.format(datetime.date.today().isoformat())
		print('attempting to save mapping to: {}'.format(ofile))
		walked = etree.tostring(dw.xmlroot,pretty_print=True)
		f = open(os.path.join(os.getcwd(),'{}.xml'.format('whereswaldo')),'wb')
		f.write(walked)
		f.close()
		print('file saved: {}'.format(ofile))
	except Exception as e:
		print(e)
		print('FATAL ERROR: but stay calm.')
	print('execution time: {} seconds'.format(clock()-start))
	raw_input()
	# print(dw.root_dir)
	# dw.find_the_mutants()
	# print(walked)
	# print()
	# print(etree.tostring(dw.xmlroot,pretty_print=True))
	# print('\n\n\n\n')
	# # print(etree.tostring(dw.xmlroot, pretty_print=True))
	# with open(os.path.join(os.getcwd(),'dir.xml'),'w') as f:
	# 	# etree.tostring(dw.xmlroot, pretty_print=True)
	# 	f.write('\n\n\n\n')
	# 	# f.write(etree.tostring(dw.xmlroot, pretty_print=True))
	# 	f.write('\n\n\n\n')
	# 	# f.write(etree.tostring(dw.xmlroot))
	# 	# print(etree.tostring(root, pretty_print=True)) 
	# 	# f.write("".join(chr(int("".join(map(str,l[i:i+8])),2)) for i in range(0,len(l),8)))
	# print(etree.tostring(dw.xmlroot)
	# # print(os.getcwd())
	# f = open(os.path.join(os.getcwd(),'dir2.xml'),'w')
	# f.write(str(str(etree.tostring(dw.xmlroot, pretty_print=True),'utf-8')))
	# f.close()
