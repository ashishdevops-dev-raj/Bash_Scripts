#!/bin/bash

# Oracle credentials
ORACLE_USER="admin"
ORACLE_PASS="Flipkart@123"
ORACLE_DB="(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.10.50)(PORT=1521))(CONNECT_DATA=(SID=PCMSUAT)))"

# Email list
EMAILS="'m.mohammad@flipkart.com','sandeep.kumar3@flipkart.com'"
ORG_ID="102"

sqlplus -s "$ORACLE_USER/$ORACLE_PASS@$ORACLE_DB" <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET ECHO ON
SET FEEDBACK ON

-- Update bulk employee table
UPDATE ES.xxfki_concur_bulk_emp
SET STATUS = '1821', ACTIVE = 'A'
WHERE email IN ($EMAILS) AND es_org_id = '$ORG_ID';

-- Update users table
UPDATE ES.es_users
SET STATUS = '1'
WHERE email IN ($EMAILS) AND es_org_id = '$ORG_ID';

COMMIT;
EXIT;
EOF
