#!/usr/bin/awk -f

BEGIN {
	# perharps, it will improve perf.
	printf "PRAGMA journal_mode = OFF;"
}
{
	printf "UPDATE Test SET date = \"%s\", balance = balance + \"%s\" WHERE account = \"%s\";\n", $3, $4, $2;
}
