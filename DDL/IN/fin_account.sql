CREATE SET TABLE Financial_DB.fin_account ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      account_id INTEGER NOT NULL,
      district_id BYTEINT NOT NULL,
      create_date DATE FORMAT 'yyyy-mm-dd' NOT NULL,
      frequency CHAR(1) CHARACTER SET LATIN UPPERCASE NOT CASESPECIFIC CHECK ( frequency  IN ('M','W','T') ) NOT NULL, 
FOREIGN KEY ( district_id ) REFERENCES WITH NO CHECK OPTION Financial_DB.fin_district ( district_id ))
UNIQUE PRIMARY INDEX ( account_id );