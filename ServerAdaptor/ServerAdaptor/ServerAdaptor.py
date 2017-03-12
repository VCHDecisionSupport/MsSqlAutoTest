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
        self.__info['SQL_SERVER_NAME'] = self.__connection.getinfo(
            pyodbc.SQL_SERVER_NAME)
        self.__info['SQL_DRIVER_ODBC_VER'] = self.__connection.getinfo(
            pyodbc.SQL_DRIVER_ODBC_VER)
        print('ODBC Connection Info (SQLGetInfo)')
        for key, value in self.__info.items():
            print('\t{}: {}'.format(key, value))

    def connect(self):
        if self.__connection is None:
            print('\tconnecting to: {}'.format(self.__dns_name))
            try:
                self.__connection = pyodbc.connect(
                    self.__source_connection_string)
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
    # def set_table_count_queries(self):
    #    cur = self.__connection.cursor()
    #    self.__table_count_queries = {}
    #    for table_row in cur.tables():
    #        table_fq = '"{}"."{}"."{}"'
    #        self.__table_count_queries[table[

    def tables(self):
        cur = self.__connection.cursor()
        return cur.tables()

    def columns(self):
        cur = self.__connection.cursor()
        return cur.columns()


class Schema(OdbcServerConnection):
    def __init__(self, dsn_name):
        self.__dns_name = dsn_name
        self.__table_name_format = None
        return super(Schema, self).__init__(self.__dns_name)

    def databases(self):
        raise NotImplementedError()


class DenodoSchema(Schema):
    def __init__(self, dsn_name):
        self.__dns_name = dsn_name
        print('{}: {}'.format(self.__class__.__name__, self.__dns_name))
        return super(DenodoSchema, self).__init__(self.__dns_name)

    def databases(self):
        self.__database_query = 'SELECT DISTINCT DATABASE_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
        self.query('databases', self.__database_query)
        return self['databases']


class MsSql(Schema):
    def __init__(self, dsn_name):
        self.__dns_name = dsn_name
        self.__databases = []
        print('{}: {}'.format(self.__class__.__name__, self.__dns_name))
        return super(MsSql, self).__init__(self.__dns_name)

    def databases(self):
        self.__database_query = """EXEC sp_MSforeachdb 'SELECT ''?''';"""
        self.query('databases', self.__database_query)
        if len(self.__databases) == 0:
            while self['databases'].nextset():
                for x in self['databases']:
                    self.__databases.append(x)
        return self.__databases


if __name__ == '__main__':
    con = OdbcServerConnection('SysDsnWwi')
    con.query('sys', 'SELECT COUNT(*) FROM sys.tables')
    con.info()

    sql = MsSql('SysDsnWwi')
    # print(list(sql.databases()))
    # print(list(sql.tables()))
    # print(list(sql.columns()))

    #den = DenodoSchema('DenodoODBCa')
    # print(list(den.databases()))
    # print(list(den.tables()))
    # print(list(den.columns()))


#'SELECT DISTINCT DATABASE_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
#'SELECT DISTINCT VIEW_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
#'SELECT DISTINCT COLUMN_NAME FROM CATALOG_VDP_METADATA_VIEWS();'
