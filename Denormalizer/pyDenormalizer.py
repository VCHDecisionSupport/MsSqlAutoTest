import pymssql, networkx as nx, matplotlib.pyplot as plt
from collections import namedtuple
from BizRuleMaker import BizRule

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
with pymssql.connect(server, user, password, database) as conn:
	# read sql source file
	with open(query_file) as sqlfile:
		query = sqlfile.read()
		# connect to SQL Server
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
	if i == 0:
		print('\n\n\n')
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
			if parent_tables_node.Parent in DiG:
				print('{} already exists in graph'.format(parent_tables_node.Parent))
			DiG.add_edge(table_name,parent_tables_node.Parent,{'Column':parent_tables_node.Column})

		# CurrentPositions is list of parent table names
		TraverseUp(parent_names,i+1)


# create SQL for Biz Rule
# def getSql(node,i=0,colNames=None):
# 	# print('node: {}'.format(node))
# 	if i == 0:
# 		colNames=[]
# 		print('\nSELECT *\nFROM {}'.format(node))
# 		# for edge in DiG.out_edges(node):
# 			# return getSql(edge[1],i+1)
# 	for edge in DiG.out_edges(node):
# 		# print('\tedge: {}->{} {}'.format(*edge,DiG.get_edge_data(*edge)))
# 		colNames.append(DiG.get_edge_data(*edge)['Column'])
# 		print('{}JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],DiG.get_edge_data(*edge)['Column'],edge[0],DiG.get_edge_data(*edge)['Column']))
# 		getSql(edge[1],i+1,colNames)
# 	return colNames
# print(getSql('dbo.CaseNoteContactFact'))

def getSubGraph(node,subgraph=None):
	if subgraph == None:
		subgraph = nx.DiGraph(database=database, server=server, root=node)
	for edge in DiG.out_edges(node):
		subgraph.add_edge(node, edge[1],{'Column':DiG.get_edge_data(*edge)['Column']})
		getSubGraph(edge[1],subgraph)
	return subgraph

def generateSqlParts(node,i=0,colNames=None,sql=None):
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
		generateSqlParts(edge[1],i+1,colNames,sql)
	return colNames,sql

def getSql(node):
	colNames,sql = generateSqlParts(node)
	gotcha='SELECT\n\t{}\nFROM {}\n{}'.format('\n\t,'.join(colNames),table_name,'\n'.join(sql))
	return gotcha

if __name__ == '__main__':
	# send leaf table names to TraverseUp to initiate one walk for each leaf
	TraverseUp(Leafs)
	fout.close()
	table_name='dbo.ReferralFact'
	sql=getSql(table_name)
	br = BizRule()
	br.action_sql = sql.replace("'","''")
	br.short_name = 'populate denomalized columns: {}'.format(table_name)
	br.rule_desc = 'populates non-source columns from parent fact and dim tables: {}'.format(table_name)
	br.sequence = 666
	br.target_table = table_name
	br.target_column = 'many'
	subgraph = getSubGraph(table_name)

	for n in subgraph:
		print(n)

	nx.draw_spring(DiG)
	plt.draw()
	plt.show()

	nx.draw_spring(subgraph)
	plt.draw()
	plt.show()
	with open('BizRule.sql','w') as fout:
		fout.write(str(br))