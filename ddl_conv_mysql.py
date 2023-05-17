import pandas as pd
import snowflake.connector
import pyodbc
import re

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

source_database='mysql'
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
teradata_ddl_file = r'C:\Users\susmita.s\Documents\Python Scripts\my_sql_sample.sql'
with open(teradata_ddl_file, 'r') as file:
    teradata_ddl = file.read()
    # .replace('     ', '')

# Step 5: Convert Teradata DDL to Snowflake DDL
snowflake_ddl = teradata_ddl
for source_data_type, snowflake_data_type in data_type_mappings.items():
    snowflake_ddl = snowflake_ddl.replace(source_data_type, snowflake_data_type)

# Step 6: Adjust any other syntax or keywords or extra spaces

#To remove check constraint with comma

pattern = ''

if re.search(r'CHECK.*\n\s', snowflake_ddl, flags=re.MULTILINE):
    final_sf_ddl1 = re.sub(r'CHECK.*\n\s', '', snowflake_ddl, flags=re.MULTILINE)
elif re.search(r',?\n\s*CHECK.*\n\)', snowflake_ddl, flags=re.MULTILINE):
    final_sf_ddl1 = re.sub(r',?\n\s*CHECK.*\n\)', ')', snowflake_ddl, flags=re.MULTILINE)
else:
    final_sf_ddl1 = snowflake_ddl

# Step 7: Print or save the Snowflake DDL
print(final_sf_ddl1)

# Or save to a file
snowflake_ddl_file = 'C:\\Users\\susmita.s\\Documents\\Python Scripts\\final_snowflake_ddl.sql'
with open(snowflake_ddl_file, 'w') as file:
    file.write(final_sf_ddl1)