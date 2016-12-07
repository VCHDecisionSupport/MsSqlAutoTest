import os

F = os.listdir('z:')

for i in range(len(F)):
	print(F[i])
	dir = 'z:/'
	srcpath = os.path.join(dir, F[i])
	dstpath = os.path.join(dir, F[i].replace('DS-',''))
	print(dstpath)
	# os.rename(srcpath, dstpath)