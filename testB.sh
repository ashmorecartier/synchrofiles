#!/usr/bin/env bash

NBACCOUNT=50000
NBOPERAT=10000

##############################################################################################
echo
echo 'test update bank accounts with operations'
echo 'need sqlite3 and awk, can take some time...'

which sqlite3 > /dev/null 2>&1 || { echo 'sqlite3 not present --> passed'; exit 1; }
which awk > /dev/null 2>&1 || { echo 'awk not present --> passed'; exit 1; }

echo 'generating files'

# create file balance
rm -f t/balance.dat && ./test/generate-balance.py --num $NBACCOUNT > t/balance.dat

# create file operation
rm -f t/operation.dat && ./test/generate-operation.py --num $NBOPERAT | LC_ALL=C sort +1n -2 +2n -3 > t/operation.dat

echo 'calculating new balance file'

# treatment
./synchrofiles.py --filea t/operation.dat --fileb t/balance.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }

echo 'finished'

# create schema
cat <<_ACEOF | sqlite3 t/table.db
DROP TABLE IF EXISTS Test;
VACUUM;
CREATE TABLE Test(
	account VARCHAR NON NULL PRIMARY KEY,
	date VARCHAR NON NULL,
	balance REAL NON NULL
);
_ACEOF

# insert balance file
NBLIGNE=`wc -l < t/balance.dat` && ./test/insert.awk -v Nbligne=$NBLIGNE t/balance.dat | sqlite3 t/table.db

# update with operation
./test/update.awk t/operation.dat | sqlite3 t/table.db >> /dev/null

# select result.sql.dat
cat <<_ACEOF | sqlite3 t/table.db
.mode column
.output t/result.sql.dat
SELECT account, date, balance FROM Test GROUP BY account, date ORDER BY account, date;
_ACEOF

# format result
./test/format.awk < t/result.sql.dat > t/result.sql.format.dat
diff t/result.dat t/result.sql.format.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/balance.dat t/operation.dat t/result.dat t/table.db t/result.sql.dat t/result.sql.format.dat
