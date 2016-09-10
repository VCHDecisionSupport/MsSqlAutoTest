import os,sys,numpy as np,itertools,csv
from collections import namedtuple
from operator import attrgetter

Join = namedtuple('Join', 'Child,Column,Parent')

Joins = [j for j in map(Join._make, csv.reader(open("data2.txt", "r")))]

# get roots: rows where Child field is not the Parent field in another row
Childs = set([j.Child for j in Joins])
Parents = set([j.Parent for j in Joins])
Leafs = list(Childs - Parents)
Roots = [j for j in list(Parents - Childs)]



# input leaf nodes:
# for l in Roots:
# 	R = [j for j in Joins if j.Parent == l]
# 	print(l)
# 	print(R)
# 	for r in R:
# 		print('\t{}'.format(r.Child))
# 		X = [j for j in Joins if j.Parent == r.Child]
# 		print('\t{}'.format(X))
global XYZ
XYZ = {}
def Traverse(TreeContext,i=0):
	if i > 10:
		return 0
	for Table in TreeContext:
		# if XYZ == None:
			# XYZ = {}
		ContextRoot = [j for j in Joins if j.Parent == Table]
		XYZ[Table] = ContextRoot
		print('{}{}'.format('\t'*i,Table))
		# if len(ContextRoot) < 0:
		# 	print('{}{}'.format('\t'*i,ContextRoot))
		# if len(ContextRoot) == 0:
			# return XYZ
		NextContext = [j.Child for j in Joins if j.Parent == Table]
		Traverse(NextContext,i+1)
# print(Traverse(Roots))
# print(XYZ)


XYZ = {}
def Traverse(TreeContext,i=0):
	if i > 10:
		return 0
	for Table in TreeContext:
		# if XYZ == None:
			# XYZ = {}
		ContextRoot = [j for j in Joins if j.Child == Table]
		if len(ContextRoot) > 0:
			XYZ[Table] = ContextRoot
		print('{}{}'.format('\t'*i,Table))
		# if len(ContextRoot) < 0:
		# 	print('{}{}'.format('\t'*i,ContextRoot))
		# if len(ContextRoot) == 0:
			# return XYZ
		NextContext = [j.Parent for j in Joins if j.Child == Table]
		Traverse(NextContext,i+1)
Traverse(Leafs)
print(XYZ)

# print(len(XYZ.keys()))