#!/usr/bin/awk -f

{
	printf "%s %s %18.2f\n", $1, $2, $3;
}
