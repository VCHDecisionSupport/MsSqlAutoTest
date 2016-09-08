import numpy as np

nptype=np.dtype([('level','i8'),('cschema','S10'),('tab','S20'),('col','S20'),('psch','S20'),('TAB','S20')])
nptype=np.dtype([('cschema','S10'),('tab','S20'),('col','S20'),('psch','S20'),('TAB','S20')])
arr=np.loadtxt('data2.txt',nptype)

B = np.repeat(True,len(arr))
# print(B)
def foo(elem=None,i=None):
	if sum(np.arange(0,len(arr))[B]) == 0:
		return 0
	if elem == None:
		# joins[arr[i]['tab']] = []
		# elem=arr[i]

		if i != None:
			B[i] = False
		else:
			i = np.min(np.arange(0,len(arr))[B])
		print('next leaf {} (i={})'.format(arr[i],i))

		foo(arr[i]['TAB'])
	else:
		print('sibling node: {}'.format(elem))
		# print('find parent nodes')
		A = arr['TAB'] == elem
		# print(A)
		I = np.arange(0,len(arr))[A]
		if len(I) > 0:
			print('parent node(s): {}'.format(arr[A]))
			for i in I:
				B[i] = False
				# print(B)
				# print(I)
			if sum(np.arange(0,len(arr))[B]) == 0:
				return 0
			foo(arr[min(np.arange(0,len(arr))[B])]['TAB'])
	foo()
	# print(sum(B==True))
	# if sum(B==True) <= 0:
	# 	return 0
	# print(np.arange(0,len(arr))[B])
	# foo(None,np.min(np.arange(0,len(arr))[B]))
		# # # no duplicates
		# # A *= elem != arr
		# I = np.arange(0,len(A))[A]
		# for i in I:
		# 	print('join to :{}'.format(arr[i]))
		# 	joins[arr[i]['tab']].append(arr[i])
		# print('find parent nodes')
		# B = elem['TAB'] == arr['tab']
		# J = np.arange(0,len(B))[B]
		# for j in J:
		# 	print('elem to parent:{}'.format(arr[j]))
		# 	joins.append(arr[j])

		# # print(I)
		# if len(I) == 0:
		# 	print('find a sibling')
		# 	B = elem['tab'] == arr['tab']
		# 	J = np.arange(0,len(B))[B]
		# 	for j in J:

		# 	if len(J) == 0 or i > max(J):
		# 		print('no more siblings')
		# 		joins.append(elem)
		# 		foo(elem=None,i=+1)
		# 	else:
		# 		print('iter over found siblings')
		# 		for j in I[1:-1]:
		# 			if j > max(I):
		# 				print('no more siblings...')
		# 				foo(elem=None,i=+1)
		# 			else:
		# 				print('add another sibling')
		# 				joins.append(arr[j])
		# 				foo(elem=None,i=+1)
foo(i=0)
# print(joins)
