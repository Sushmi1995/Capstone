import pandas as pd
import snowflake.connector
import pyodbc
import os

# Step 1: Connect to the database
# conn = snowflake.connector.connect(
#     user='varsha21',
#     password='Varsha21',
#     account='dt82474.ap-southeast-1',
#     warehouse='COMPUTE_WH',
#     database='ddl_conv',
#     schema='PUBLIC'
# )

# Define the connection string
server = '10.10.132.50'
database = 'adw_hackathon'
username = 'hackathon'
password = 'infocepts@09876'
driver = 'ODBC Driver 13 for SQL Server'  # Replace with the appropriate driver name

# Create the connection string
connection_string = f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}'

# Connect to the database
db = pyodbc.connect(connection_string)

source_database='teradata'
source_name=source_database+'_data_type'

# Step 2: Read table information from the database
table_name = 'metadata_table'
query = f"select * from {table_name}"
df = pd.read_sql_query(query, db)
# print('df==',df)

# Step 3: Create data type mappings
data_type_mappings = {}
for index, row in df.iterrows():
    # column_name = row['name']
    #print(column_name)
    source_data_type = row[source_name]
    snowflake_data_type = row['snowflake_data_type']
    # print('teradata',source_data_type)
    # print('Snowflake',snowflake_data_type)
    data_type_mappings[source_data_type] = snowflake_data_type
    # print(data_type_mappings)

# # Step 4: Extract Teradata DDL from the local SQL file
teradata_ddl_file = r'C:\Users\susmita.s\Documents\Python Scripts\DDL\IN\\fin_account.sql'
with open(teradata_ddl_file, 'r') as file:
    teradata_ddl = file.read().replace('     ', '')
   

# Step 5: Convert Teradata DDL to Snowflake DDL
snowflake_ddl = teradata_ddl
for source_data_type, snowflake_data_type in data_type_mappings.items():
    # print("Before==\n",snowflake_ddl)
    # print("source_data_type",source_data_type,"\n")
    # print("snowflake_data_type",snowflake_data_type,"\n")
    snowflake_ddl = snowflake_ddl.replace(source_data_type, snowflake_data_type)
    # Removes Blank lines from ddl
    snowflake_ddl = os.linesep.join([s for s in snowflake_ddl.splitlines() if s])
    

# Step 6: Adjust any other syntax or keywords specific to Teradata

# Step 7: Print or save the Snowflake DDL
print(snowflake_ddl)
# Or save to a file
# snowflake_ddl_file = 'snowflake_ddl.sql'
# with open(snowflake_ddl_file, 'w') as file:
#     file.write(snowflake_ddl)