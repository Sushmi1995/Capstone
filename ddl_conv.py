import re
import os
import sys
#import pandas as pd
import time
import glob2
import configparser
# import logger_mysql as log
#import logger_csv as jlog
import shutil
#import openpyxl as op
from datetime import datetime

ddl_in_sql_folder_path=r'C:\Users\susmita.s\Documents\Python Scripts\DDL\IN'
file_list = glob2.glob(ddl_in_sql_folder_path + "\\**.sql")
    # glob2 use **
flag = 0
flag_n = 0
no_of_objects_process = 0
print('file_list',file_list)
for filename in file_list:
    no_of_objects_process += 1
    file = open(filename, 'r', encoding="utf8")
    s = re.compile(r'\w*.sql', re.IGNORECASE)
    match = re.findall(s, filename)
    data = file.read().replace('\r\n', '\n')
    print('s=',s,'\n','m=',match,'\n','d=',data)



        