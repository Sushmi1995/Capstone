#Import necessary libraries or packages
import pandas as pd
import snowflake.connector
import pyodbc
import re
import os
import configparser

# Load the properties file and read from the properties file
config = configparser.ConfigParser()
config.read(r'C:\Users\varsha.r\Desktop\ddl_conversion\documents.properties')      
server = config.get('info', 'server')
database = config.get('info', 'database')
username = config.get('info', 'username')
password = config.get('info', 'password')
driver = config.get('info', 'driver')
source_database = config.get('info', 'source_database')
table_name = config.get('info', 'table_name')
source_ddl_file = config.get('info', 'source_ddl_file')
snowflake_ddl_file = config.get('info', 'snowflake_ddl_file')

## Step 1: Connect to the database
# Create the connection string
connection_string = f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}'

# Connect to the database
db = pyodbc.connect(connection_string)

# change the source db to column name of metadata table
source_name=source_database+'_data_type'

## Step 2: Read table information from the database
query = f"select * from {table_name}"
df = pd.read_sql_query(query, db)

## Step 3: Create data type mappings
data_type_mappings = {}
for index, row in df.iterrows():
    source_data_type = row[source_name]
    snowflake_data_type = row['snowflake_data_type']
    data_type_mappings[source_data_type] = snowflake_data_type

## Step 4: Extract DDL from the local SQL file
with open(source_ddl_file, 'r') as file:
    source_ddl = file.read().replace('     ', '') #replace the extra space in ddl document

## Step 5: Convert source DDL to Snowflake DDL
snowflake_ddl = source_ddl
for source_data_type, snowflake_data_type in data_type_mappings.items():
    snowflake_ddl = snowflake_ddl.replace(source_data_type, snowflake_data_type)

## Step 6: Adjust any other syntax or keywords or extra spaces

if source_database == 'teradata':

#Compress keyword and following substituted with blank
    final_sf_ddl1 = re.sub(r'COMPRESS \([^)]+\)', '', snowflake_ddl)
    final_sf_ddl2 = re.sub(r'COMPRESS\s*', '', final_sf_ddl1)

    #identifying the primary key and foreign key clauses
    primary_key_pattern = r"PRIMARY KEY \((.*?)\)"
    foreign_key_pattern = r"FOREIGN KEY \((.*?)\) REFERENCES (.*?) \((.*?)\),\s"

    #Split the Snowflake DDL statements into a list
    ddl_statements = final_sf_ddl2.split(';')

    #Construct the modified Snowflake DDL for each statement
    modified_ddl_statements = []
    #find the primary key and foreign key clauses
    for ddl_statement in ddl_statements:
        primary_keys = re.findall(primary_key_pattern, ddl_statement)
        foreign_keys = re.findall(foreign_key_pattern, ddl_statement)
        #Strip any leading or trailing whitespace from the DDL statement
        snowflake_ddl_modified = ddl_statement.strip()

        #Remove the primary key clause
        #Remove any trailing whitespace and semicolon
        #Add the modified primary key clause
        if primary_keys:
            snowflake_ddl_modified = re.sub(primary_key_pattern, '', snowflake_ddl_modified)
            snowflake_ddl_modified = snowflake_ddl_modified.rstrip().rstrip(';')
            snowflake_ddl_modified += f",\nPRIMARY KEY ({primary_keys[0].strip()})"
        
        #Remove the foreign key clause
        #Remove any trailing whitespace and semicolon
        #Add the modified foreign key clause
        if foreign_keys:
            snowflake_ddl_modified = re.sub(foreign_key_pattern, '', snowflake_ddl_modified)
            foreign_key_columns = [  
                            f"FOREIGN KEY ({col[0].strip()}) REFERENCES {col[1].strip()} ({col[2].strip()}) "for col in foreign_keys]
            
            #Join the modified foreign key clauses with a comma and newline separator
            foreign_key_clause= ',\n'.join(foreign_key_columns)
            snowflake_ddl_modified += f",\n{foreign_key_clause}"

        #Append the modified DDL statement to the list of modified DDL statements
        modified_ddl_statements.append(snowflake_ddl_modified)

    #Join the modified DDL statements back into a single string
        modified_snowflake_ddl = ';\n'.join(modified_ddl_statements)

    #To remove extra space and few other keywords
    semi_colon_removal = modified_snowflake_ddl.replace(r";", ");")\
                                            .replace(r"NULL),","NULL,")

    final_snowflake_ddl = re.sub(r"\s+\(", "(", semi_colon_removal) 
    final_snowflake_ddl1 = re.sub(r'\n\)\,\nPRIMARY', '\nPRIMARY', final_snowflake_ddl)
    CONVERTED_SNOWFLAKE_DDL = re.sub(r'\)\,\nPRIMARY', ',\nPRIMARY', final_snowflake_ddl1)

elif source_database == 'mysql':

    if re.search(r'CHECK.*\n\s*', snowflake_ddl, flags=re.MULTILINE):
        final_sf_ddl1 = re.sub(r'CHECK.*\n\s*', '', snowflake_ddl, flags=re.MULTILINE)
    elif re.search(r',?\n\s*CHECK.*', snowflake_ddl, flags=re.MULTILINE):
        final_sf_ddl1 = re.sub(r',?\n\s*CHECK.*', '', snowflake_ddl, flags=re.MULTILINE)
    else:
        final_sf_ddl1 = snowflake_ddl

    #To remove comma if it is the last column definition
    final_sf_ddl2 = re.sub(r',\n\s*\);', '\n);', final_sf_ddl1)
    #To replace enum datatype to varchar
    CONVERTED_SNOWFLAKE_DDL = re.sub(r'ENUM\(.*\)', 'VARCHAR', final_sf_ddl2)

elif source_database == 'postgress':

    final_sf_ddl = re.sub(r"\s+\(", "(", snowflake_ddl)

    #geometry datatype substituion - SRID is always 4326.
    CONVERTED_SNOWFLAKE_DDL = re.sub(r"GEOMETRY\(.*\)", "GEOMETRY", final_sf_ddl)

##Step 7: Print or save the Snowflake DDL
print(CONVERTED_SNOWFLAKE_DDL)

# snowflake_ddl_file = 'C:\\Users\\varsha.r\\Desktop\\ddl_conversion\\final_snowflake_ddl.sql'
with open(snowflake_ddl_file, 'w') as file:
    file.write(CONVERTED_SNOWFLAKE_DDL)