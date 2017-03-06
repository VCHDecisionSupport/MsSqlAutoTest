import pyodbc
import operator
class OdbcServerConnection(object):
    def __init__(self, dsn_name):
        self.__dns_name = dsn_name
        self.__source_connection_string = r'DSN={}'.format(self.__dns_name)
        self.__connection = None
        self.__cursors = {}
        print('{}: {}'.format(self.__class__.__name__, self.__dns_name))
    def info(self):
        self.connect()
        self.__info = {}
        self.__info['SQL_SERVER_NAME'] = self.__connection.getinfo(pyodbc.SQL_SERVER_NAME)
        self.__info['SQL_DRIVER_ODBC_VER'] = self.__connection.getinfo(pyodbc.SQL_DRIVER_ODBC_VER)
        #self.__info['SQL_INSERT_STATEMENT'] = self.__connection.getinfo(pyodbc.SQL_INSERT_STATEMENT)
        #self.__info['SQL_INFO_SCHEMA_VIEWS'] = self.__connection.getinfo(pyodbc.SQL_INFO_SCHEMA_VIEWS)
        print('ODBC Connection Info (SQLGetInfo)')
        for key,value in self.__info.items():
            print('\t{}: {}'.format(key, value))
    def connect(self):
        if self.__connection is None:
            print('\tconnecting to: {}'.format(self.__dns_name))
            try:
                self.__connection = pyodbc.connect(self.__source_connection_string)
            except Exception as e:
                print(e)
    def query(self, query_name, query_str):
        self.connect()
        self.__cursors[query_name] = self.__connection.cursor()
        self.__cursors[query_name].execute(query_str)
    def sql_cmd(self, cmd_name, cmd_str, cmd_params):
        self.connect()
        if isinstance(cmd_param_list, list):
            if isinstance(cmd_param_list[0], tuple):
                print('list of tuples -> executemany()')
                self.__cursors[cmd_name] = self.__connection.cursor()
                self.__cursors[cmd_name].executemany(query_str, cmd_params)
        if isinstance(cmd_params, tuple):
            print('tuple -> execute()')
            self.__cursors[cmd_name] = self.__connection.cursor()
            self.__cursors[cmd_name].execute(query_str, cmd_params)
    def __getitem__(self, key):
        if key in self.__cursors:
            return self.__cursors[key]
        else:
            raise KeyError('there is no query with name: {}'.format(key))
    def __del__(self):
        print('committing changes to: {}'.format(self.__dns_name))
        self.__connection.commit()
        print('\tclosing'.format(self.__dns_name))
        self.__connection.close()
    def tables(self):
        cur = self.__connection.cursor()
        for x in cur.tables():
            print(x)
    def columns(self):
        cur = self.__connection.cursor()
        for x in cur.columns():
            print(x)

class Schema(OdbcServerConnection):
    def __init__(self, dsn_name):
        self.__dns_name = dsn_name
        print('{}: {}'.format(self.__class__.__name__, self.__dns_name))
        return super(Schema, self).__init__(self.__dns_name)
    def get_databases(self):
        raise NotImplementedError()
    def get_view_tables(self, database_name=None):
        raise NotImplementedError()
    def get_columns(self, database_name=None, view_table_name=None):
        raise NotImplementedError()

class DenodoSchema(Schema):
    def __init__(self, dsn_name):
        self.__dns_name = dsn_name
        print('{}: {}'.format(self.__class__.__name__, self.__dns_name))
        return super(DenodoSchema, self).__init__(self.__dns_name)
    def get_databases(self):
        self.__database_query = 'SELECT DISTINCT DATABASE_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
        self.query('databases', self.__database_query)
        return self['databases']
    def get_view_tables(self, database_name=None):
        if database_name is None:
            self.__view_table_query = 'SELECT DISTINCT DATABASE_NAME, VIEW_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
        else:
            self.__view_table_query = "SELECT DISTINCT DATABASE_NAME, VIEW_NAME FROM CATALOG_VDP_METADATA_VIEWS() WHERE DATABASE_NAME = '{}';".format(database_name)
        self.query('view_tables', self.__view_table_query)
        return self['view_tables']
    def get_columns(self, database_name=None, view_table_name=None):
        if database_name is None:
            self.__view_table_query = 'SELECT DISTINCT DATABASE_NAME, VIEW_NAME, COLUMN_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
        elif view_table_name is None:
            self.__view_table_query = "SELECT DISTINCT DATABASE_NAME, VIEW_NAME, COLUMN_NAME FROM CATALOG_VDP_METADATA_VIEWS() WHERE DATABASE_NAME = '{}';".format(database_name)
        else:
            self.__view_table_query = "SELECT DISTINCT DATABASE_NAME, VIEW_NAME, COLUMN_NAME FROM CATALOG_VDP_METADATA_VIEWS() WHERE DATABASE_NAME = '{}' AND VIEW_NAME = '{}';".format(database_name, view_table_name)
        self.query('columns', self.__view_table_query)
        return self['columns']
    def foo(self):
        self.tables()

class MsSql(Schema):
    def __init__(self, dsn_name):
        self.__dns_name = dsn_name
        print('{}: {}'.format(self.__class__.__name__, self.__dns_name))
        return super(MsSql, self).__init__(self.__dns_name)
    def get_databases(self):
        self.__database_query = 'SELECT DISTINCT DATABASE_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
        self.query('databases', self.__database_query)
        return self['databases']
    def get_view_tables(self, database_name=None):
        if database_name is None:
            self.__view_table_query = 'SELECT DISTINCT DATABASE_NAME, VIEW_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
        else:
            self.__view_table_query = "SELECT DISTINCT DATABASE_NAME, VIEW_NAME FROM CATALOG_VDP_METADATA_VIEWS() WHERE DATABASE_NAME = '{}';".format(database_name)
        self.query('view_tables', self.__view_table_query)
        return self['view_tables']
    def get_columns(self, database_name=None, view_table_name=None):
        if database_name is None:
            self.__view_table_query = 'SELECT DISTINCT DATABASE_NAME, VIEW_NAME, COLUMN_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
        elif view_table_name is None:
            self.__view_table_query = "SELECT DISTINCT DATABASE_NAME, VIEW_NAME, COLUMN_NAME FROM CATALOG_VDP_METADATA_VIEWS() WHERE DATABASE_NAME = '{}';".format(database_name)
        else:
            self.__view_table_query = "SELECT DISTINCT DATABASE_NAME, VIEW_NAME, COLUMN_NAME FROM CATALOG_VDP_METADATA_VIEWS() WHERE DATABASE_NAME = '{}' AND VIEW_NAME = '{}';".format(database_name, view_table_name)
        self.query('columns', self.__view_table_query)
        return self['columns']

if __name__ == '__main__':
    con = OdbcServerConnection('SysDsnWwi')
    con.query('sys', 'SELECT COUNT(*) FROM sys.tables')
    con.info()

    den = OdbcServerConnection('DenodoODBCa')
    #den.query('SELECT COUNT(*) FROM sys.tables','sys')
    den.info()

    den = DenodoSchema('DenodoODBCa')
    print(list(den.get_databases()))
    print(list(den.get_view_tables()))
    print(list(den.get_columns()))
    den.tables()
    den.columns()
    #con.sql_cmd('sdfa',[(1,2,3),(432,2,1)])
    #cur = con['sys']
    #print(cur)
    #res = cur.fetchall()
    #print(res)
    #print(type(res))
    #for r in res:
    #    print(r)

#'SELECT DISTINCT DATABASE_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
#'SELECT DISTINCT VIEW_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
#'SELECT DISTINCT COLUMN_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
