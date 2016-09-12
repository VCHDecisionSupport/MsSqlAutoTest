import pymssql, networkx as nx, matplotlib.pyplot as plt
from collections import namedtuple
from BizRuleMaker import BizRule

# TODO: generate table alias in sql
# TODO: handle cycles (eg CaseNoteHeader has SourceSystemClientID column but also joins to ReferralFact which has SourceSystemClientID)
# TODO: handle quoting is BR generation
# TODO: document sql query, generate docstring

# """
# 	pySqlGraph.SqlGraph uses Networkx to generate 
# 	python C:\Users\gcrowell\AppData\Local\Programs\Python\Python35\Lib\pydoc.py -w Z:\GITHUB\PyUtilities\Denormalizer\pySqlGraph.py
# """

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
	
	def get_joins(self):
		"""
			connects to Sql Server, loads query from file, executes query and loads results into list of namedtuple Join
		"""
		print('connecting to Sql Server:\n\tserver: {server}\n\tdatabase: {database}'.format(**self.__dict__))
		Join = namedtuple('Join', 'Child,Column,Parent')
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
		if i == 0:
			print('\n\n\n')
		# loop over each traversal position
		for table_name in current_nodes:
			# get list of parent nodes of this table (if any exist) from Joins (ie sql query results)
			parent_tables_nodes = [j for j in self.joins if j.Child == table_name]
			# print to console
			print('{}{}'.format('\t'*i,table_name))
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
		if i == 0:
			sql=[]
			colNames=[]
			print('\nSELECT *\nFROM {}'.format(node))
		for edge in self.DiG.out_edges(node):
			# print('\tedge: {}->{} {}'.format(*edge,self.DiG.get_edge_data(*edge)))
			colNames.append('{}.{}'.format(edge[0],self.DiG.get_edge_data(*edge)['Column']))
			print('{}LEFT JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],self.DiG.get_edge_data(*edge)['Column'],edge[0],self.DiG.get_edge_data(*edge)['Column']))
			sql.append('{}LEFT JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],self.DiG.get_edge_data(*edge)['Column'],edge[0],self.DiG.get_edge_data(*edge)['Column']))
			self._generate_sql_parts(edge[1],i+1,colNames,sql)
		# remove colNames of root
		good_colNames = []
		for colName in colNames:
			if node not in colName:
				good_colNames.append(colName)
		return good_colNames,sql

	def _generate_subgraph_sql_parts(self, node, subgraph, i=0,colNames=None,sql=None):
		""" 
			generates sql string parts from self.DiG (assumes self.DiG already exists) that are combined into useable string in self.get_sql(table_name) 
			called by self.get_sql(table_name)
			utility function that traverses up DiGraph object generating joins and column name list 

			TODO: node is redundant and should be inferred from subgraph
		"""
		if i == 0:
			sql=[]
			colNames=[]
			print('\nSELECT *\nFROM {}'.format(node))
		for edge in subgraph.out_edges(node):
			# print('\tedge: {}->{} {}'.format(*edge,subgraph.get_edge_data(*edge)))
			colNames.append('{}.{}'.format(edge[0],subgraph.get_edge_data(*edge)['Column']))
			print('{}LEFT JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],subgraph.get_edge_data(*edge)['Column'],edge[0],subgraph.get_edge_data(*edge)['Column']))
			sql.append('{}LEFT JOIN {}\n{}ON {}.{}={}.{}'.format('\t'*i,edge[1],'\t'*i,edge[1],subgraph.get_edge_data(*edge)['Column'],edge[0],subgraph.get_edge_data(*edge)['Column']))
			self._generate_subgraph_sql_parts(edge[1],subgraph,i+1,colNames,sql)
		# remove colNames of root
		good_colNames = []
		for colName in colNames:
			if node not in colName:
				good_colNames.append(colName)
		return good_colNames,sql


	def get_sql(self, table_name):
		"""
			interface function that returns sql string 
		"""
		colNames,sql = self._generate_sql_parts(table_name)
		query='SELECT\n\t{}\nFROM {}\n{}'.format('\n\t,'.join(colNames),table_name,'\n'.join(sql))
		return query

	def get_sql2(self, table_name):
		pass
	def get_subgraph(self,node,subgraph=None):
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
		if table_name in self.DiG:
			subgraph = self.generate_graph(table_name)
			nx.draw_spring(subgraph)
			plt.draw()
			plt.show()
			return True
		nx.draw_spring(self.DiG)
		plt.draw()
		plt.show()
	def save_BizRule(self,table_name=None):
		if table_name == None:
			for n in self.DiG:
				sql = self.get_sql(n)
				br = BizRule()
				br.short_name = n
				br.action_sql = sql
				with open('BizRule_{}.sql'.format(n),'w') as fout:
					fout.write(str(br))
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
		with pymssql.connect(self.server, self.user, self.password, self.database) as conn:
			query = self.get_sql(table_name)
			# connect to SQL Server
			# init query
			cur = conn.cursor()
			print('executing query')
			cur.execute(query)
if __name__ == '__main__':
	dargs = {'server' : 'STDBDECSUP02','database' : 'CommunityMart','user' : 'VCH\gcrowell','password' : '2AND2is5.', 'query_file' : 'DenormalizeFact.sql'}
	sql_graph = SqlGraph(**dargs)
	sql_graph.generate_graph()
	
	# sql_graph.save_BizRule()
	table_name='dbo.ReferralFact'
	sql_graph.save_sql(table_name)
	subgraph=sql_graph.get_subgraph(table_name)
	sql_graph._generate_subgraph_sql_parts(table_name,subgraph)