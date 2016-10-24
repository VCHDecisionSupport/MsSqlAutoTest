import pymssql, networkx as nx, matplotlib.pyplot as plt
from collections import namedtuple
from BizRuleMaker import BizRule

denormalize_query_script='DenormalizeFact.sql'
# TODO: generate table alias in sql
# TODO: handle cycles (eg CaseNoteHeader has SourceSystemClientID column but also joins to ReferralFact which has SourceSystemClientID)
# TODO: handle quoting is BR generation
# TODO: document sql query, generate docstring

# """
# 	pySqlGraph.SqlGraph uses Networkx to generate 
# 	python C:\Users\gcrowell\AppData\Local\Programs\Python\Python35\Lib\pydoc.py -w Z:\GITHUB\PyUtilities\Denormalizer\pySqlGraph.py
# """

def get_query(table_name, colNames, sql):
	colClause = ''
	if len(colNames) > 0:
		if 'CommunityMart.dbo.PersonFact.SourceSystemClientID' in colNames:
			colNames.append('CommunityMart.dbo.PersonFact.PatientID')
		colClause = ','+'\n\t\t,'.join(colNames)
		# print(colClause)
	return 'SELECT\n\t\t{}.ETLAuditID\n\t\t{}\nFROM {}\n{}'.format(table_name,colClause,table_name,'\n'.join(sql))

merge_sql_fmt = """
;WITH src AS (
	{src_sql}
)
MERGE INTO {dst_table} AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET \n{set_clause}
;
"""

def get_alias(table_name):
	# vowels = 'aoeui'
	suffix = '_fact'
	if table_name[-4:len(table_name)] == 'Fact':
		table_name = table_name[0:-4]
	else:
		suffix = '_dim'

	# alias = table_name.split('.')[1].lower()[0:4]+(''.join([l for l in (table_name.split('.')[1].lower()[4:len(table_name)]) if l not in vowels]))[0] + suffix
	alias = table_name.split('.')[1].lower() + suffix
	# print('{} alias {}'.format(table_name,alias))
	return alias

class SqlGraph(object):
	"""SqlGraph generates a Directed Graph from Sql joins that are implied by column names and AutoTest profiles"""
	def __init__(self, server, user, password, database, query_file):
		super(SqlGraph, self).__init__()
		self.server = server
		self.user = user
		self.password = password
		self.database = database
		self.query_file=query_file
		# init variable to store query results
		self.joins = None
		# init Networkx DiGraph (directed graph) object
		self.DiG = nx.DiGraph(database=self.database, server=self.server)
		self.altered_tables = []
	def get_joins(self):
		"""
			connects to Sql Server, loads query from file, executes query and loads results into list of namedtuple Join
		"""
		print('connecting to Sql Server:\n\tserver: {server}\n\tdatabase: {database}'.format(**self.__dict__))
		# Child: <schema>.<table>
		# Parent: <schema>.<table>
		# Column: <column>
		Join = namedtuple('Join', 'Child,Column,Datatype,Parent')
		with pymssql.connect(self.server, self.user, self.password, self.database) as conn:
			# read sql source file
			print('reading query_file: {}'.format(self.query_file))
			with open(self.query_file) as sqlfile:
				query = sqlfile.read()
				# connect to SQL Server
				# init query
				cur = conn.cursor()
				print('executing query')
				cur.execute(query)
				# load query results into list of namedtuple python data structure
				self.joins = [j for j in map(Join._make, cur)]
				# leave file, sql connection contexts
	def generate_graph(self):
		"""
			convience function
			calls self.get_joins() if needed
			interface to recursive graph building functions
		"""
		if self.joins == None:
			self.get_joins()
		print('generating Networkx DiGraph object of {database} from query results'.format(**self.__dict__))
		# save distinct Child column values
		childs = set([j.Child for j in self.joins])
		# save distinct Parent column values
		parents = set([j.Parent for j in self.joins])
		# save names of Leaf tables
		leafs = list(childs - parents)
		self._traverse_joins(leafs)
	def _traverse_joins(self, current_nodes,i=0):
		"""
			builds/populates Networkx DiGraph object self.DiG repersenting entire database
			recurses from each Child position in current_nodes list to their Parent(s)  
			current_nodes is list of positions (ie table names) in database graph 
		"""
		# if i == 0:
		# 	print('\n\n\n')
		# loop over each traversal position
		for table_name in current_nodes:
			# get list of parent nodes of this table (if any exist) from Joins (ie sql query results)
			parent_tables_nodes = [j for j in self.joins if j.Child == table_name]
			# print to console
			# print('{}{}'.format('\t'*i,table_name))
			# print to file
			# fout.write('{}{}\n'.format('\t'*i,table_name))
			# extract names from each Parent node for next recursive call
			parent_names = [parent_node.Parent for parent_node in parent_tables_nodes]
			for parent_tables_node in parent_tables_nodes:
				self.DiG.add_edge(table_name,parent_tables_node.Parent,{'Column':parent_tables_node.Column})
			# CurrentPositions is list of parent table names
			self._traverse_joins(parent_names,i+1)
	def _generate_sql_parts(self, node,i=0,colNames=None,sql=None):
		""" 
			generates sql string parts from self.DiG (assumes self.DiG already exists) that are combined into useable string in self.get_sql(table_name) 
			called by self.get_sql(table_name)
			utility function that traverses up DiGraph object generating joins and column name list 

			TODO: instead of using self.DiG (ie graph of entire) could use subgraph from given node
		"""
		referencesPersonFact = False
		if i == 0:
			sql=[]
			colNames=[]
			# print('\nSELECT *\nFROM {}'.format(node))
		for edge in self.DiG.out_edges(node):
			# print('\tedge: {}->{} {}'.format(*edge,self.DiG.get_edge_data(*edge)))
			colNames.append('{}.{}'.format(edge[1],self.DiG.get_edge_data(*edge)['Column']))
			# print('{}LEFT JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],self.DiG.get_edge_data(*edge)['Column'],edge[0],self.DiG.get_edge_data(*edge)['Column']))
			sql.append('{}LEFT JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],self.DiG.get_edge_data(*edge)['Column'],edge[0],self.DiG.get_edge_data(*edge)['Column']))
			self._generate_sql_parts(edge[1],i+1,colNames,sql)
			# if 'dbo.PersonFact' in edge[0] or 'dbo.PersonFact' in edge[1]:
				# referencesPersonFact = True
		# print('_generate_sql_parts')
		# print(colNames)
		# if referencesPersonFact and 'CommunityMart.dbo.PersonFact.PatientID' not in colNames:
			# colNames.append('CommunityMart.dbo.PersonFact.PatientID')
		net_new_colNames = []
		# remove colNames of already in leaf table
		for colName in colNames:
			if node not in colName:
				net_new_colNames.append(colName)
		return net_new_colNames,sql
	def _generate_subgraph_sql_parts(self, node, subgraph, i=0,colNames=None,sql=None):
		""" 
			generates sql string parts from self.DiG (assumes self.DiG already exists) that are combined into useable string in self.get_sql(table_name) 
			called by self.get_sql(table_name)
			utility function that traverses up DiGraph object generating joins and column name list 

			TODO: node is redundant and should be inferred from subgraph
		"""
		referencesPersonFact = False
		if i == 0:
			sql=[]
			colNames=[]
			# print('\nSELECT *\nFROM {}'.format(node))
		for edge in subgraph.out_edges(node):
			# print('\tedge: {}->{} {}'.format(*edge,subgraph.get_edge_data(*edge)))
			colNames.append('{}.{}'.format(edge[0],subgraph.get_edge_data(*edge)['Column']))
			# print('{}LEFT JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],subgraph.get_edge_data(*edge)['Column'],edge[0],subgraph.get_edge_data(*edge)['Column']))
			sql.append('{}LEFT JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],subgraph.get_edge_data(*edge)['Column'],edge[0],subgraph.get_edge_data(*edge)['Column']))
			self._generate_subgraph_sql_parts(edge[1],subgraph,i+1,colNames,sql)
			if 'dbo.PersonFact' in edge[0] or 'dbo.PersonFact' in edge[1]:
				referencesPersonFact = True
		# print('_generate_subgraph_sql_parts')
		# if referencesPersonFact and 'CommunityMart.dbo.PersonFact.PatientID' not in colNames:
			# colNames.append('CommunityMart.dbo.PersonFact.PatientID')
		# remove colNames of already in leaf table
		net_new_colNames = []
		for colName in colNames:
			if node not in colName:
				net_new_colNames.append(colName)
		return net_new_colNames,sql
	def get_sql(self, table_name):
		"""
			interface function that returns sql string 
		"""
		colNames,sql = self._generate_sql_parts(table_name)
		return get_query(table_name, colNames, sql)
	def save_deploy_sql(self):
		with open('sqlcmd_deployment.sql','w') as fdeployout:
			fdeployout.write("""	PRINT '
	executing sqlcmd_deployment.sql with variable pathvar $(pathvar)'

DECLARE @path varchar(500) = '$(pathvar)'
RAISERROR('@path = $(pathvar) = %s

',0,1,@path) WITH NOWAIT""")
			for table_name in self.altered_tables:
				fdeployout.write('\n:r $(pathvar)/Table/ALTER-{}.sql'.format(table_name))
	def save_alter_sql(self, table_name):
		"""
			creates alter statements to add columns 
		"""
		alter_sql = ''
		scripted_alters = []
		colNames,sql = self._generate_sql_parts(table_name)
		for elem in self.joins:
			colName = '{}.{}'.format(elem.Parent,elem.Column)
			print(colName)
			if colName in colNames and colName not in scripted_alters:
				if colName == 'CommunityMart.dbo.PersonFact.SourceSystemClientID' and 'CommunityMart.dbo.PersonFact.SourceSystemClientID' not in scripted_alters:
					scripted_alters.append(colName)
					alter = "\nUSE CommunityMart\nGO\n\nIF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = '{}' AND OBJECT_NAME(col.object_id) = '{}') \nBEGIN\n\tALTER TABLE {} ADD {} {} NULL;\n\tPRINT '{}';\nEND\n".format('PatientID',table_name.split('.')[2],table_name,'PatientID','int','PatientID')
					alter = "\nUSE CommunityMart\nGO\n\nIF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = '{}' AND OBJECT_NAME(col.object_id) = '{}') \nBEGIN\n\tALTER TABLE {} ALTER COLUMN {} {} NULL;\n\tPRINT '{}';\nEND\n".format('PatientID',table_name.split('.')[2],table_name,'PatientID','int','PatientID')
					alter_sql += alter
				scripted_alters.append(colName)
				alter = "\nUSE CommunityMart\nGO\n\nIF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = '{}' AND OBJECT_NAME(col.object_id) = '{}') \nBEGIN\n\tALTER TABLE {} ADD {} {} NULL;\n\tPRINT '{}';\nEND\n".format(elem.Column,table_name.split('.')[2],table_name,elem.Column,elem.Datatype,colName)
				alter = "\nUSE CommunityMart\nGO\n\nIF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = '{}' AND OBJECT_NAME(col.object_id) = '{}') \nBEGIN\n\tALTER TABLE {} ALTER COLUMN {} {} NULL;\n\tPRINT '{}';\nEND\n".format(elem.Column,table_name.split('.')[2],table_name,elem.Column,elem.Datatype,colName)

				alter_sql += alter
				print(alter)
		with open('Table/ALTER-{}.sql'.format(table_name),'w') as fout:
			self.altered_tables.append(table_name)
			fout.write(alter_sql)
		return alter_sql
	def get_subgraph(self, node,subgraph=None):
		"""
			recurses up self.DiG from given node (ie table name)  building/populating a subgraph object
		"""
		if subgraph == None:
			subgraph = nx.DiGraph(database=self.database, server=self.server, root=node)
		for edge in self.DiG.out_edges(node):
			# subgraph.add_node(edge[1],{'alias':get_alias(edge[1])})
			# if edge[0] in subgraph:
			# 	print('child node: {} already in subgraph'.format(edge[0]))
			# if edge[1] in subgraph:
			# 	print('parent node: {} already in subgraph'.format(edge[1]))
			# get_alias(edge[0])
			subgraph.add_edge(node, edge[1],{'Column':self.DiG.get_edge_data(*edge)['Column']})
			self.get_subgraph(edge[1],subgraph)
		# for node in subgraph:
		# 	subgraph[node]['alias'] = get_alias(node)
		return subgraph
	### short cut functions
	def plot_sql(self, table_name=None):
		"""
			use matplotlib plotting module to show visual of graph
			if table_name == None then show database graph, else show subgraph from table_name
		"""
		labels={}
		if table_name in self.DiG:
			subgraph = self.get_subgraph(table_name)
			for node in subgraph:
				labels[node] = node
			print(labels)
			nx.draw_spring(subgraph,labels=labels,font_size=8,node_size=300,alpha=0.7)
			plt.draw()
			plt.show()
			return True
		nx.draw_spring(self.DiG,labels=labels,font_size=8,node_size=300,alpha=0.7)
		plt.draw()
		plt.show()
	def save_BizRule(self,table_name=None):
		if table_name == None:
			with open('DenormalizeFact_BizRule.sql','w') as fout:
				seq = 1000
				for n in self.DiG:
					if 'Fact' in n:
						print('saving BR {}'.format(n))
						sql = self.get_merge_sql(n)
						br = BizRule()
						br.target_table = n
						br.target_column = 'many'
						br.short_name = 'Update/Merge {} (denormalize)'.format(n)
						br.action_sql = sql
						br.sequence = seq
						fout.write(str(br))
						self.save_alter_sql(n)
						seq += 100
			self.save_deploy_sql()
		else:
			sql = self.get_sql(table_name)
			br = BizRule()
			br.short_name = table_name
			br.action_sql = sql
			with open('BizRule_{}.sql'.format(table_name),'w') as fout:
				fout.write(str(br))
	def save_sql(self, table_name=None):
		if table_name == None:
			for n in self.DiG:
				sql = self.get_sql(n)
				with open('{}.sql'.format(n),'w') as fout:
					fout.write(str(sql))
		else:
			sql = self.get_sql(table_name)
			with open('{}.sql'.format(table_name),'w') as fout:
				fout.write(str(sql))
	def test_sql(self, table_name):
		print('connecting to Sql Server:\n\tserver: {server}\n\tdatabase: {database}'.format(**self.__dict__))
		# self.server = 'STDBDECSUP02'
		with pymssql.connect(self.server, self.user, self.password, self.database) as conn:
			query = self.get_sql(table_name)
			# connect to SQL Server
			# init query
			cur = conn.cursor()
			print('executing query')
			cur.execute(query)
	def get_merge_sql(self, table_name):
		colNames,sql = self._generate_sql_parts(table_name)
		query = get_query(table_name, colNames, sql)
		set_clause=',\n'.join(['\tdst.{}=src.{}'.format(colName.split('.')[3],colName.split('.')[3]) for colName in colNames])
		merge_sql = merge_sql_fmt.format(src_sql=query,dst_table=table_name,set_clause=set_clause)
		return merge_sql
if __name__ == '__main__':
	dargs = {'server' : 'STDBDECSUP02','database' : 'CommunityMart','user' : 'VCH\gcrowell','password' : '2AND2is5.', 'query_file' : denormalize_query_script}
	sql_graph = SqlGraph(**dargs)
	sql_graph.generate_graph()
	sql_graph.save_BizRule()
	# sql_graph.save_alter_sql()
	# sql_graph.save_deploy_sql()
	# sql_graph.get_merge_sql(table_name)
	# table_name = 'CommunityMart.dbo.ReferralFact'
	# table_name = 'CommunityMart.dbo.SchoolHistoryFact'
	# query = sql_graph.get_merge_sql(table_name)
	# print(query)

