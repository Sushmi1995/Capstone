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