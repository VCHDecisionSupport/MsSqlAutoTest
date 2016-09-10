import pymssql, networkx as nx
from collections import namedtuple

#################################################################
#
# read sql source file, execute it, load results to a convienient data structure
#
#################################################################

# init Sql Server connection params
server = 'STDBDECSUP02'
user = 'VCH\gcrowell'
password = '2AND2is5.'
database = 'CommunityMart'
# assume sql source folder is in current working directory
query_file = 'DenormalizeFact.sql'

# init variable to store query results
Joins = None
# read sql source file
with open(query_file) as sqlfile:
	query = sqlfile.read()
	# connect to SQL Server
	with pymssql.connect(server, user, password, database) as conn:
		# init query
		cur = conn.cursor()
		cur.execute(query)
		# load query results into list of namedtuple python data structure
		Join = namedtuple('Join', 'Child,Column,Parent')
		Joins = [j for j in map(Join._make, cur)]
		print(Joins)
		# leave file, sql connection contexts


#################################################################
#
# now create join tree by starting for leaf node and iteratively traversing until a root is eached
#
#################################################################

### get distinct leaf tables names (eg AssessmentContactFact)
### Child column values from rows where Parent field is not equal to the Child field in any other row

# save distinct Child column values
Childs = set([j.Child for j in Joins])
# save distinct Parent column values
Parents = set([j.Parent for j in Joins])
# save names of Leaf tables
Leafs = list(Childs - Parents)

# init dictionary (ie map/hash table) of lists to store traversals
global JoinSequence,fout, DiG
JoinSequence = dict()

# directed graph
DiG = nx.DiGraph(database=database, server=server)

# init file to write formatted output
fout = open('{}.txt'.format(database),'w')

# define traversal function that, for each given table, recursively populates dict with parent nodes
# TraverseUp: 
# CurrentPositions: list of table names; each element in list repersents a unique traversal
# i: recursion level; formatting helper
def TraverseUp(CurrentPositions,i=0):
	# loop over each traversal position
	for table_name in CurrentPositions:
		# get list of parent nodes of this table (if any exist) from Joins (ie sql query results)
		parent_tables_nodes = [j for j in Joins if j.Child == table_name]
		# if parents found save them in JoinSequence
		if len(parent_tables_nodes) > 0:
			JoinSequence[table_name] = parent_tables_nodes
		
		# print to console
		print('{}{}'.format('\t'*i,table_name))
		fout.write('{}{}\n'.format('\t'*i,table_name))
		# extract names from each Parent node for next recursive call
		parent_names = [parent_node.Parent for parent_node in parent_tables_nodes]
		for parent_tables_node in parent_tables_nodes:
			DiG.add_edge(table_name,parent_tables_node.Parent,{'Column':parent_tables_node.Column})

		# CurrentPositions is list of parent table names
		TraverseUp(parent_names,i+1)

# send leaf table names to TraverseUp to initiate one walk for each leaf
TraverseUp(Leafs)
fout.close()
# create SQL for Biz Rule
def getSql(node,i=0,colNames=None):
	# print('node: {}'.format(node))
	if i == 0:
		colNames=[]
		print('\nSELECT *\nFROM {}'.format(node))
		# for edge in DiG.out_edges(node):
			# return getSql(edge[1],i+1)
	for edge in DiG.out_edges(node):
		# print('\tedge: {}->{} {}'.format(*edge,DiG.get_edge_data(*edge)))
		colNames.append(DiG.get_edge_data(*edge)['Column'])
		print('{}JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],DiG.get_edge_data(*edge)['Column'],edge[0],DiG.get_edge_data(*edge)['Column']))
		getSql(edge[1],i+1,colNames)
	return colNames
# print(getSql('dbo.CaseNoteContactFact'))


def getSql(node,i=0,colNames=None,sql=None):
	# print('node: {}'.format(node))
	if i == 0:
		sql=[]
		colNames=[]
		print('\nSELECT *\nFROM {}'.format(node))
		# for edge in DiG.out_edges(node):
			# return getSql(edge[1],i+1)
	for edge in DiG.out_edges(node):
		# print('\tedge: {}->{} {}'.format(*edge,DiG.get_edge_data(*edge)))
		colNames.append(DiG.get_edge_data(*edge)['Column'])
		print('{}JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],DiG.get_edge_data(*edge)['Column'],edge[0],DiG.get_edge_data(*edge)['Column']))
		sql.append('{}JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],DiG.get_edge_data(*edge)['Column'],edge[0],DiG.get_edge_data(*edge)['Column']))
		getSql(edge[1],i+1,colNames,sql)
	return colNames,sql


table_name='dbo.CaseNoteContactFact'
colNames,sql = getSql(table_name)
print(colNames)
print(sql)
gotcha='SELECT\n\t{}\nFROM {}{}'.format('\n\t,'.join(colNames),table_name,'\n'.join(sql))
print(gotcha)