import lxml,os
from lxml import etree

print('pymatch . . . ')
os.chdir('Z:\\GITHUB\\PyUtilities\\pymatch')
src='b.xml'
dst='z.xml'
'''
<root path="Z:\">
  <file atime="2014-06-19" ctime="2014-06-19" filesize="304" fullpath="Z:\.apdisk" hash="d4d623b54fa54847ae6a878663fb7adbefab7fcd" index=".apdisk" mtime="2014-06-19" name=".apdisk" parent="Z:\"/>
'''
src_xml=etree.parse(src)
dst_xml=etree.parse(dst)
# xpath=etree.XPath('count(root/file/mtime=$mtime])')
# print(xpath(dst_xml))

# print(xpath(dst_xml,mtime = "2014-06-19"))

# dst_files=dst_xml.xpath('file[@mtime="2014-06-19"]')	
# print(len(dst_files)()
# print(dst_files.find("mtime"))
# print(len(dst_files))
# src_files=src_xml.xpath('file')	
# dst_files=dst_xml.xpath('file')
n=10
i=0
skipped=[]
missing=[]
for src_file in src_xml.xpath('file'):
	name = src_file.get("name")
	if "com.apple" in name:
		print('com.apple file skipped')
		skipped.append(src_file)
	else:
		try:
			print('looking for: "{}"'.format(name))
			dst_files=dst_xml.xpath('file[@name="{}"]'.format(name))
			print('\t{} files have that name'.format(len(dst_files)))
			if len(dst_files) == 0:
				missing.append(src_file)
			i+=1
			if i > n:
				break
		except UnicodeEncodeError as e:
			print(e)

print('these files werent matched')
for waldo in missing:
	print(waldo.get("name"))

# 	print(xpath)
# 	x=dst_xml.xpath(xpath)
# 	xpath=etree.XPath("count(file)")
# 	print(x)
# 	# print(src_file)
# 	# for key in src_file.keys():
# 	# 	print(key)
# 	# print(src_file.get("atime"))
# 	# print(src_file.get("atime"))
# 	# print(src_file.get("atime"))
# 	# print(src_file.get("atime"))
# 	# print(src_file.get("atime"))
# 	# for elem in src_file:
# 	# 	print(elem)
# 	# print(src_file.tag)
# 	# print(src_file.text)
# 	# break







# # src_file.close()