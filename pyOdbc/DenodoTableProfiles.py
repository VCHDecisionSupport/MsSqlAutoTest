import pyodbc
import datetime


class OdbcConnection(object):
    def __init__(self, source_dsn_name, profile_log_dsn_name):
        self.source_dsn_name = source_dsn_name
        self.profile_log_dsn_name = profile_log_dsn_name
        self.source_connection_string = r'DSN={}'.format(self.source_dsn_name)
        print('connecting to ODBC DSN: {}'.format(self.source_connection_string))
        self.source_odbc_connection = pyodbc.connect(self.source_connection_string)
        self.source_meta_cursor = None
        self.profile_log_odbc_connection = None
        self.profile_log_cursor = None
        self.table_profile_queries = {}
        self.column_profile_queries = {}
        self.column_histogram_queries = {}
        self.profile_date = datetime.datetime.today().isoformat()[0:22]
        self.pkg_key = 123

    def execute_meta_query(self, query_str):
        print('execute_meta_query("{}")'.format(query_str))
        self.source_meta_cursor = self.source_odbc_connection.cursor()
        self.source_meta_cursor.execute("{}".format(query_str))
        
    def generate_profiling_queries(self):
        current_database = None
        prev_database = None
        current_table = None
        prev_table = None
        current_column = None
        prev_column = None
        rows = self.source_meta_cursor.fetchall()
        for row in rows:
            current_database = row[2]
            current_table = row[3]
            current_column = row[5]
            fq_table = '"{}"."{}"'.format(current_database, current_table)
            fq_column = '{}.{}.{}'.format(current_database, current_table,current_column)
            if fq_table not in self.table_profile_queries:
                self.table_profile_queries[fq_table] = """SELECT '{profile_date}' AS TableProfileDate, 'DENODO' AS PackageName, '{database_name}' AS DatabaseName, '{schema_name}' AS SchemaName, '{table_name}' AS TableName, COUNT(*) AS RecordCount, {pkg_key} AS PkgKey FROM     {fq_table_name};""".format(profile_date=str(self.profile_date), database_name=current_database, schema_name='gotcha', table_name=current_table, pkg_key=self.pkg_key, fq_table_name=fq_table)
        print('\n\n{} views found.')
        print('\twith {} columns')
    def connect_to_profile_log(self):
        self.profile_log_connection_string = r'DSN={}'.format(self.profile_log_dsn_name)
        print('\n\nconnecting to ODBC DSN: {}'.format(self.profile_log_connection_string))
        self.profile_log_odbc_connection = pyodbc.connect(self.profile_log_connection_string)
        self.profile_log_cursor = self.profile_log_odbc_connection.cursor()
        proc_cmd = """\
        EXEC AutoTest.dbo.uspInsTableProfile @pProfileDateIsoStr=?, @pPackageName=?, @pDatabaseName=?, @pSchemaName=?, @pTableName=?, @pRowCount=?, @pPkgExecKey=?;
        commit;
        """
        for key,value in self.table_profile_queries.items():
            print('{}:\n\t{}'.format(key, value))
            self.profile_cursor = self.source_odbc_connection.cursor()
            try:
                self.profile_cursor.execute("{}".format(value))
                proc_params = tuple(self.profile_cursor.fetchall())[0]
                print('\t{}'.format(proc_params))
                self.profile_log_cursor.execute(proc_cmd, proc_params)
            except pyodbc.Error as e:
                print(e)

    def __del__(self):
        print('closing {}'.format(self.source_dsn_name))
        self.source_odbc_connection.close()
        if self.profile_log_odbc_connection != None:
            print('closing {}'.format(self.profile_log_dsn_name))
            self.profile_log_odbc_connection.close()

if __name__ == '__main__':
    so = OdbcConnection('DenodoODBC','DevOdbcSqlServer')
    so.execute_meta_query("SELECT * FROM CATALOG_METADATA_VIEWS() WHERE view_name IS NOT NULL;")
    so.generate_profiling_queries()
    so.connect_to_profile_log()
    print(so)