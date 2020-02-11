#!/usr/bin/awk -f

BEGIN {
	NB = Nbligne
	print "INSERT INTO Test (account, date, balance) VALUES";
}
NR != NB { printf "(\"%s\",\"%s\",\"%s\"),\n", $1, $2, $3; }
NR == NB { printf "(\"%s\",\"%s\",\"%s\");\n", $1, $2, $3; }
