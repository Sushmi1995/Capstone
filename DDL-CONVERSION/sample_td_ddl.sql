-- DDL for table fin_district                                                
CREATE SET TABLE Financial_DB.fin_district ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      district_id BYTEINT NOT NULL,
      district_name VARCHAR(19) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      region VARCHAR(15) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      num_inhabitants INTEGER,
      num_municipalities_gt499 SMALLINT,
      num_municipalities_500to1999 BYTEINT,
      num_municipalities_2000to9999 BYTEINT,
      num_municipalities_gt10000 BYTEINT,
      num_cities BYTEINT,
      ratio_urban DECIMAL(4,1),
      average_salary DECIMAL(10,2),
      unemployment_rate95 DECIMAL(3,2),
      unemployment_rate96 DECIMAL(3,2),
      num_entrep_per1000 SMALLINT,
      num_crimes95 INTEGER,
      num_crimes96 INTEGER)
UNIQUE PRIMARY INDEX ( district_id );


-- DDL for table fin_account                                                 
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


-- DDL for table fin_client                                                  
CREATE SET TABLE Financial_DB.fin_client ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      client_id INTEGER NOT NULL,
      birth_date DATE FORMAT 'yyyy-mm-dd' NOT NULL,
      gender CHAR(1) CHARACTER SET LATIN UPPERCASE NOT CASESPECIFIC NOT NULL,
      district_id BYTEINT, 
FOREIGN KEY ( district_id ) REFERENCES WITH NO CHECK OPTION Financial_DB.fin_district ( district_id ))
UNIQUE PRIMARY INDEX ( client_id );


-- DDL for table fin_disp                                                    
CREATE SET TABLE Financial_DB.fin_disp ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      disp_id INTEGER NOT NULL,
      client_id INTEGER NOT NULL,
      account_id INTEGER NOT NULL,
      disp_type CHAR(1) CHARACTER SET LATIN UPPERCASE NOT CASESPECIFIC CHECK ( disp_type  IN ('O','D') ) NOT NULL, 
FOREIGN KEY ( account_id ) REFERENCES WITH NO CHECK OPTION Financial_DB.fin_account ( account_id ),
FOREIGN KEY ( client_id ) REFERENCES WITH NO CHECK OPTION Financial_DB.fin_client ( client_id ))
UNIQUE PRIMARY INDEX ( disp_id );



-- DDL for table fin_card                                                    
CREATE SET TABLE Financial_DB.fin_card ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      card_id INTEGER NOT NULL,
      disp_id INTEGER NOT NULL,
      card_type CHAR(1) CHARACTER SET LATIN UPPERCASE NOT CASESPECIFIC CHECK ( card_type  IN ('C','G','J') ) NOT NULL,
      issued_date DATE FORMAT 'yyyy-mm-dd' NOT NULL, 
FOREIGN KEY ( disp_id ) REFERENCES WITH NO CHECK OPTION Financial_DB.fin_disp ( disp_id ))
UNIQUE PRIMARY INDEX ( card_id );


-- DDL for table fin_loan                                                    
CREATE SET TABLE Financial_DB.fin_loan ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      loan_id INTEGER NOT NULL,
      account_id INTEGER NOT NULL,
      granted_date DATE FORMAT 'yyyy-mm-dd' NOT NULL,
      amount DECIMAL(12,2) NOT NULL,
      duration SMALLINT NOT NULL,
      payments DECIMAL(12,2) NOT NULL,
      status CHAR(1) CHARACTER SET LATIN UPPERCASE NOT CASESPECIFIC CHECK ( status  IN ('A','B','C','D') ) NOT NULL, 
FOREIGN KEY ( account_id ) REFERENCES WITH NO CHECK OPTION Financial_DB.fin_account ( account_id ))
PRIMARY INDEX ( account_id );

-- DDL for table fin_order                                                   
CREATE SET TABLE Financial_DB.fin_order ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      order_id INTEGER NOT NULL,
      account_id INTEGER NOT NULL,
      bank_to VARCHAR(2) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      account_to INTEGER NOT NULL,
      amount DECIMAL(12,2) NOT NULL,
      category CHAR(2) CHARACTER SET LATIN NOT CASESPECIFIC CHECK ( category  IN ('HH','IN','LE','LO','') ) NOT NULL, 
FOREIGN KEY ( account_id ) REFERENCES WITH NO CHECK OPTION Financial_DB.fin_account ( account_id ))
PRIMARY INDEX ( account_id );

-- DDL for table fin_trans                                                   
CREATE SET TABLE Financial_DB.fin_trans ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      trans_id INTEGER NOT NULL,
      account_id INTEGER NOT NULL,
      trans_date DATE FORMAT 'yyyy-mm-dd' NOT NULL,
      amount DECIMAL(12,2) NOT NULL,
      balance DECIMAL(12,2) NOT NULL,
      trans_type CHAR(1) CHARACTER SET LATIN UPPERCASE NOT CASESPECIFIC CHECK ( trans_type  IN ('C','D','P') ) NOT NULL,
      operation CHAR(3) CHARACTER SET LATIN UPPERCASE NOT CASESPECIFIC CHECK ( operation  IN ('   ','CCW','CIC','COB','ROB','WIC') ) NOT NULL COMPRESS ('   ','CCW','CIC','COB','ROB','WIC'),
      category CHAR(2) CHARACTER SET LATIN UPPERCASE NOT CASESPECIFIC CHECK ( category  IN ('  ','HH','IC','IN','IO','LO','PE','ST') ) COMPRESS ('  ','HH','IC','IN','IO','LO','PE','ST'),
      other_bank_id CHAR(2) CHARACTER SET LATIN UPPERCASE NOT CASESPECIFIC COMPRESS ,
      other_account_id INTEGER COMPRESS , 
FOREIGN KEY ( account_id ) REFERENCES WITH NO CHECK OPTION Financial_DB.fin_account ( account_id ))
PRIMARY INDEX ( account_id )
;

