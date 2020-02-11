# synchrofiles

## How to synchronize two files with an internal key

When databases didn't exist, there were some tips and tricks to obtain the same results with formatted text files.

The problem consists in the matching of two streams according an internal key. These streams are sorted using this key and will be read each in one path. By streams, we meant a text or binary file, a memory array, or even a database cursor.
A classic example is a file transactions with an amount to apply to a file accounts balance. The key is account number.

The piece of code **synchrofiles.py** do that. Consider it as a canvas written in python3, a very simple pseudo-python3 easily translatable in another language and for your specific problem.

Two files as input

* fileA (the file of operations) :

		an id
		a keya (the matching key, the account)
		a date (the date of operation)
		an amount (the amount of operation to apply)
		separator : blank
		example : 0 000001 20200110 8532.45
		fileA must be sorted by keya, date. keya, date can be multiple.
		fileA can be stdin.

* fileB (the file of account balance) :

		a keyb (the matching key, the account)
		a date (the date of the last operation applied)
		an amount (the amount of the last balance)
		separator : blank
		example : 000001 20200101 1.0
		fileB must be sorted by keyb, date. keyb, date can be multiple.

One file as output
* fileC (the "new" file of account balance) :

		same format as fileB
		fileC will be sorted "automatically" by keyc, datec ready for another run as fileB.

Rules to create a fileC record :

* if a keya match a keyb :

		keyc <== keya
		datec <== max(last(datea) by keya, last(dateb) by keyb)
		amountc <== sum(amounta) by keya + sum(amountb) by keyb

* if a keya doesn't match any keyb :

		keyc <== keya
		datec <== last(datea) by keya
		amountc <== sum(amounta) by keya

* if a keyb doesn't match any keya :

		keyc <== keyb
		datec <== last(dateb) by keyb
		amountc <== sum(amountb) by keyb

A first technical test is provided. It should run in any linux, macos and windows/cygwin with python3.

```
	./testA.sh
```

The second test requires sqlite3 and awk. It applies 10 000 operations on 50 000 accounts. Using sqlite3, it makes 50 000 inserts followed with 10 000 updates. Depending of the IO capabilities, this can be very effective or not.
```
	./testB.sh
```
