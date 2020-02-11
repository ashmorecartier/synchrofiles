#!/usr/bin/env bash

##############################################################################################
echo
echo 'test 2 empty files'

# create empty file
rm -f t/file-empty.dat && touch t/file-empty.dat

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
**************
*  StreamA   *
* Empty File *
**************
**************
*  StreamB   *
* Empty File *
**************
_ACEOF

./synchrofiles.py --filea t/file-empty.dat --fileb t/file-empty.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/file-empty.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-empty.dat fileb-one.dat (filea empty fileb non empty)'

# create empty file
rm -f t/file-empty.dat && touch t/file-empty.dat

# create fileb with one record
rm -f t/fileb-one.dat && cat <<_ACEOF > t/fileb-one.dat
000001 20200101 100.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
**************
*  StreamA   *
* Empty File *
**************
000001 20200101             100.00
_ACEOF

./synchrofiles.py --filea t/file-empty.dat --fileb t/fileb-one.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/file-empty.dat t/fileb-one.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-one.dat fileb-empty.dat (filea non empty fileb empty)'

# create empty file
rm -f t/file-empty.dat && touch t/file-empty.dat

# create filea with one record
rm -f t/filea-one.dat && cat <<_ACEOF > t/filea-one.dat
1 000001 20200101 100.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
**************
*  StreamB   *
* Empty File *
**************
000001 20200101             100.00
_ACEOF

./synchrofiles.py --filea t/filea-one.dat --fileb t/file-empty.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/file-empty.dat t/filea-one.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-one.dat fileb-one.dat same key (filea and fileb same key)'

# create filea with one record
rm -f t/filea-one.dat && cat <<_ACEOF > t/filea-one.dat
1 000001 20200101 100.00
_ACEOF

# create fileb with one record
rm -f t/fileb-one.dat && cat <<_ACEOF > t/fileb-one.dat
000001 20200101 100.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101             200.00
_ACEOF

./synchrofiles.py --filea t/filea-one.dat --fileb t/fileb-one.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-one.dat t/fileb-one.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-one-prev.dat fileb-one.dat (filea before fileb)'

# create filea with one record before fileb
rm -f t/filea-one-prev.dat && cat <<_ACEOF > t/filea-one-prev.dat
1 000000 20200101 100.00
_ACEOF

# create fileb with one record
rm -f t/fileb-one.dat && cat <<_ACEOF > t/fileb-one.dat
000001 20200101 100.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000000 20200101             100.00
000001 20200101             100.00
_ACEOF

./synchrofiles.py --filea t/filea-one-prev.dat --fileb t/fileb-one.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-one-prev.dat t/fileb-one.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-one-after.dat fileb-one.dat (filea after fileb)'

# create filea with one record after fileb
rm -f t/filea-one-after.dat && cat <<_ACEOF > t/filea-one-after.dat
1 000002 20200101 100.00
_ACEOF

# create fileb with one record
rm -f t/fileb-one.dat && cat <<_ACEOF > t/fileb-one.dat
000001 20200101 100.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101             100.00
000002 20200101             100.00
_ACEOF

./synchrofiles.py --filea t/filea-one-after.dat --fileb t/fileb-one.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-one-after.dat t/fileb-one.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-two-before.dat fileb-one.dat (filea two before fileb)'

# create filea with two records key 0
rm -f t/filea-two-before.dat && cat <<_ACEOF > t/filea-two-before.dat
1 000000 20200101 100.00
2 000000 20200101 100.00
_ACEOF

# create fileb with one record
rm -f t/fileb-one.dat && cat <<_ACEOF > t/fileb-one.dat
000001 20200101 100.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000000 20200101             200.00
000001 20200101             100.00
_ACEOF

./synchrofiles.py --filea t/filea-two-before.dat --fileb t/fileb-one.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-two-before.dat t/fileb-one.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-imbriq-before.dat fileb-imbriq-before.dat (filea imbriq with fileb, filea before)'

# create filea imbricated before fileb
rm -f t/filea-imbriq-before.dat && cat <<_ACEOF > t/filea-imbriq-before.dat
1 000000 20200101 100.00
2 000002 20200101 200.00
3 000004 20200101 400.00
4 000006 20200101 600.00
5 000008 20200101 800.00
6 000010 20200101 1000.00
7 000012 20200101 1200.00
8 000014 20200101 1400.00
9 000016 20200101 1600.00
10 000018 20200101 1800.00
12 000020 20200101 2000.00
_ACEOF

# create fileb imbricated with filea before
rm -f t/fileb-imbriq-before.dat && cat <<_ACEOF > t/fileb-imbriq-before.dat
000001 20200101 1.00
000003 20200101 3.00
000005 20200101 5.00
000007 20200101 7.00
000009 20200101 9.00
000011 20200101 11.00
000013 20200101 13.00
000015 20200101 15.00
000017 20200101 17.00
000019 20200101 19.00
000021 20200101 21.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000000 20200101             100.00
000001 20200101               1.00
000002 20200101             200.00
000003 20200101               3.00
000004 20200101             400.00
000005 20200101               5.00
000006 20200101             600.00
000007 20200101               7.00
000008 20200101             800.00
000009 20200101               9.00
000010 20200101            1000.00
000011 20200101              11.00
000012 20200101            1200.00
000013 20200101              13.00
000014 20200101            1400.00
000015 20200101              15.00
000016 20200101            1600.00
000017 20200101              17.00
000018 20200101            1800.00
000019 20200101              19.00
000020 20200101            2000.00
000021 20200101              21.00
_ACEOF

./synchrofiles.py --filea t/filea-imbriq-before.dat --fileb t/fileb-imbriq-before.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-imbriq-before.dat t/fileb-imbriq-before.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-imbriq-after.dat fileb-imbriq-after.dat (filea imbriq with fileb, filea after)'

# create filea imbricated after fileb
rm -f t/filea-imbriq-after.dat && cat <<_ACEOF > t/filea-imbriq-after.dat
1 000001 20200101 100.00
2 000003 20200101 300.00
3 000005 20200101 500.00
4 000007 20200101 700.00
5 000009 20200101 900.00
6 000011 20200101 1100.00
7 000013 20200101 1300.00
8 000015 20200101 1500.00
9 000017 20200101 1700.00
10 000019 20200101 1900.00
12 000021 20200101 2100.00
_ACEOF

# create fileb imbricated with filea after
rm -f t/fileb-imbriq-after.dat && cat <<_ACEOF > t/fileb-imbriq-after.dat
000000 20200101 0.00
000002 20200101 2.00
000004 20200101 4.00
000006 20200101 6.00
000008 20200101 8.00
000010 20200101 10.00
000012 20200101 12.00
000014 20200101 14.00
000016 20200101 16.00
000018 20200101 18.00
000020 20200101 20.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000000 20200101               0.00
000001 20200101             100.00
000002 20200101               2.00
000003 20200101             300.00
000004 20200101               4.00
000005 20200101             500.00
000006 20200101               6.00
000007 20200101             700.00
000008 20200101               8.00
000009 20200101             900.00
000010 20200101              10.00
000011 20200101            1100.00
000012 20200101              12.00
000013 20200101            1300.00
000014 20200101              14.00
000015 20200101            1500.00
000016 20200101              16.00
000017 20200101            1700.00
000018 20200101              18.00
000019 20200101            1900.00
000020 20200101              20.00
000021 20200101            2100.00
_ACEOF

./synchrofiles.py --filea t/filea-imbriq-after.dat --fileb t/fileb-imbriq-after.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-imbriq-after.dat t/fileb-imbriq-after.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-standard-one.dat fileb-standard.dat (filea one with fileb standard)'

# create filea standard one
rm -f t/filea-standard-one.dat && cat <<_ACEOF > t/filea-standard-one.dat
0 000006 20200102 100.00
_ACEOF

# create fileb standard
rm -f t/fileb-standard.dat && cat <<_ACEOF > t/fileb-standard.dat
000001 20200101 50.00
000002 20200101 60.00
000003 20200101 70.00
000004 20200101 80.00
000005 20200101 90.00
000006 20200101 100.00
000007 20200101 110.00
000008 20200101 120.00
000009 20200101 130.00
000010 20200101 140.00
000011 20200102 200.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101              50.00
000002 20200101              60.00
000003 20200101              70.00
000004 20200101              80.00
000005 20200101              90.00
000006 20200102             200.00
000007 20200101             110.00
000008 20200101             120.00
000009 20200101             130.00
000010 20200101             140.00
000011 20200102             200.00
_ACEOF

./synchrofiles.py --filea t/filea-standard-one.dat --fileb t/fileb-standard.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-standard-one.dat t/fileb-standard.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-standard-two.dat fileb-standard.dat (filea two with fileb standard)'

# create filea standard two
rm -f t/filea-standard-two.dat && cat <<_ACEOF > t/filea-standard-two.dat
0 000006 20200102 100.00
0 000006 20200103 100.00
_ACEOF

# create fileb standard
rm -f t/fileb-standard.dat && cat <<_ACEOF > t/fileb-standard.dat
000001 20200101 50.00
000002 20200101 60.00
000003 20200101 70.00
000004 20200101 80.00
000005 20200101 90.00
000006 20200101 100.00
000007 20200101 110.00
000008 20200101 120.00
000009 20200101 130.00
000010 20200101 140.00
000011 20200102 200.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101              50.00
000002 20200101              60.00
000003 20200101              70.00
000004 20200101              80.00
000005 20200101              90.00
000006 20200103             300.00
000007 20200101             110.00
000008 20200101             120.00
000009 20200101             130.00
000010 20200101             140.00
000011 20200102             200.00
_ACEOF

./synchrofiles.py --filea t/filea-standard-two.dat --fileb t/fileb-standard.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-standard-two.dat t/fileb-standard.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-standard-three.dat fileb-standard.dat (filea three with fileb standard)'

# create filea standard three
rm -f t/filea-standard-three.dat && cat <<_ACEOF > t/filea-standard-three.dat
0 000006 20200102 100.00
0 000006 20200103 100.00
0 000006 20200104 100.00
_ACEOF

# create fileb standard
rm -f t/fileb-standard.dat && cat <<_ACEOF > t/fileb-standard.dat
000001 20200101 50.00
000002 20200101 60.00
000003 20200101 70.00
000004 20200101 80.00
000005 20200101 90.00
000006 20200101 100.00
000007 20200101 110.00
000008 20200101 120.00
000009 20200101 130.00
000010 20200101 140.00
000011 20200102 200.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101              50.00
000002 20200101              60.00
000003 20200101              70.00
000004 20200101              80.00
000005 20200101              90.00
000006 20200104             400.00
000007 20200101             110.00
000008 20200101             120.00
000009 20200101             130.00
000010 20200101             140.00
000011 20200102             200.00
_ACEOF

./synchrofiles.py --filea t/filea-standard-three.dat --fileb t/fileb-standard.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-standard-three.dat t/fileb-standard.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-standard-four.dat fileb-standard.dat (filea four with fileb standard)'

# create filea standard four
rm -f t/filea-standard-four.dat && cat <<_ACEOF > t/filea-standard-four.dat
0 000006 20200102 100.00
0 000006 20200103 100.00
0 000006 20200104 100.00
0 000006 20200105 100.00
_ACEOF

# create fileb standard
rm -f t/fileb-standard.dat && cat <<_ACEOF > t/fileb-standard.dat
000001 20200101 50.00
000002 20200101 60.00
000003 20200101 70.00
000004 20200101 80.00
000005 20200101 90.00
000006 20200101 100.00
000007 20200101 110.00
000008 20200101 120.00
000009 20200101 130.00
000010 20200101 140.00
000011 20200102 200.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101              50.00
000002 20200101              60.00
000003 20200101              70.00
000004 20200101              80.00
000005 20200101              90.00
000006 20200105             500.00
000007 20200101             110.00
000008 20200101             120.00
000009 20200101             130.00
000010 20200101             140.00
000011 20200102             200.00
_ACEOF

./synchrofiles.py --filea t/filea-standard-four.dat --fileb t/fileb-standard.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-standard-four.dat t/fileb-standard.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-standard-five.dat fileb-standard.dat (filea five with fileb standard)'

# create filea standard five
rm -f t/filea-standard-five.dat && cat <<_ACEOF > t/filea-standard-five.dat
0 000006 20200102 100.00
0 000006 20200103 100.00
0 000006 20200104 100.00
0 000006 20200105 100.00
0 000006 20200106 100.00
_ACEOF

# create fileb standard
rm -f t/fileb-standard.dat && cat <<_ACEOF > t/fileb-standard.dat
000001 20200101 50.00
000002 20200101 60.00
000003 20200101 70.00
000004 20200101 80.00
000005 20200101 90.00
000006 20200101 100.00
000007 20200101 110.00
000008 20200101 120.00
000009 20200101 130.00
000010 20200101 140.00
000011 20200102 200.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101              50.00
000002 20200101              60.00
000003 20200101              70.00
000004 20200101              80.00
000005 20200101              90.00
000006 20200106             600.00
000007 20200101             110.00
000008 20200101             120.00
000009 20200101             130.00
000010 20200101             140.00
000011 20200102             200.00
_ACEOF

./synchrofiles.py --filea t/filea-standard-five.dat --fileb t/fileb-standard.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-standard-five.dat t/fileb-standard.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-standard-six.dat fileb-standard.dat (filea six with fileb standard)'

# create filea standard six
rm -f t/filea-standard-six.dat && cat <<_ACEOF > t/filea-standard-six.dat
0 000006 20200102 100.00
0 000006 20200103 100.00
0 000006 20200104 100.00
0 000006 20200105 100.00
0 000006 20200106 100.00
0 000006 20200107 100.00
_ACEOF

# create fileb standard
rm -f t/fileb-standard.dat && cat <<_ACEOF > t/fileb-standard.dat
000001 20200101 50.00
000002 20200101 60.00
000003 20200101 70.00
000004 20200101 80.00
000005 20200101 90.00
000006 20200101 100.00
000007 20200101 110.00
000008 20200101 120.00
000009 20200101 130.00
000010 20200101 140.00
000011 20200102 200.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101              50.00
000002 20200101              60.00
000003 20200101              70.00
000004 20200101              80.00
000005 20200101              90.00
000006 20200107             700.00
000007 20200101             110.00
000008 20200101             120.00
000009 20200101             130.00
000010 20200101             140.00
000011 20200102             200.00
_ACEOF

./synchrofiles.py --filea t/filea-standard-six.dat --fileb t/fileb-standard.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-standard-six.dat t/fileb-standard.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-standard-seven.dat fileb-standard.dat (filea seven with fileb standard)'

# create filea standard seven
rm -f t/filea-standard-seven.dat && cat <<_ACEOF > t/filea-standard-seven.dat
0 000006 20200102 100.00
0 000006 20200103 100.00
0 000006 20200104 100.00
0 000006 20200105 100.00
0 000006 20200106 100.00
0 000006 20200107 100.00
0 000006 20200108 100.00
_ACEOF

# create fileb standard
rm -f t/fileb-standard.dat && cat <<_ACEOF > t/fileb-standard.dat
000001 20200101 50.00
000002 20200101 60.00
000003 20200101 70.00
000004 20200101 80.00
000005 20200101 90.00
000006 20200101 100.00
000007 20200101 110.00
000008 20200101 120.00
000009 20200101 130.00
000010 20200101 140.00
000011 20200102 200.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101              50.00
000002 20200101              60.00
000003 20200101              70.00
000004 20200101              80.00
000005 20200101              90.00
000006 20200108             800.00
000007 20200101             110.00
000008 20200101             120.00
000009 20200101             130.00
000010 20200101             140.00
000011 20200102             200.00
_ACEOF

./synchrofiles.py --filea t/filea-standard-seven.dat --fileb t/fileb-standard.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-standard-seven.dat t/fileb-standard.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-standard-after.dat fileb-standard.dat (filea after with fileb standard)'

# create filea standard seven
rm -f t/filea-standard-after.dat && cat <<_ACEOF > t/filea-standard-after.dat
0 000012 20200102 100.00
0 000012 20200103 100.00
0 000012 20200104 100.00
0 000012 20200105 100.00
0 000012 20200106 100.00
0 000012 20200107 100.00
0 000012 20200108 100.00
_ACEOF

# create fileb standard
rm -f t/fileb-standard.dat && cat <<_ACEOF > t/fileb-standard.dat
000001 20200101 50.00
000002 20200101 60.00
000003 20200101 70.00
000004 20200101 80.00
000005 20200101 90.00
000006 20200101 100.00
000007 20200101 110.00
000008 20200101 120.00
000009 20200101 130.00
000010 20200101 140.00
000011 20200102 200.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000001 20200101              50.00
000002 20200101              60.00
000003 20200101              70.00
000004 20200101              80.00
000005 20200101              90.00
000006 20200101             100.00
000007 20200101             110.00
000008 20200101             120.00
000009 20200101             130.00
000010 20200101             140.00
000011 20200102             200.00
000012 20200108             700.00
_ACEOF

./synchrofiles.py --filea t/filea-standard-after.dat --fileb t/fileb-standard.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-standard-after.dat t/fileb-standard.dat t/expected.dat t/result.dat

##############################################################################################
echo
echo 'test filea-standard.dat fileb-standard.dat (filea standard with fileb standard)'

# create filea standard
rm -f t/filea-standard.dat && cat <<_ACEOF > t/filea-standard.dat
0 000000 20200102 100.00
0 000000 20200102 100.00
1 000001 20200101 100.00
2 000001 20200101 110.00
3 000001 20200101 120.00
4 000001 20200101 130.00
5 000005 20200101 140.00
6 000006 20200101 150.00
7 000007 20200101 160.00
8 000008 20200101 170.00
9 000009 20200101 180.00
10 000010 20200101 190.00
11 000010 20200101 190.00
_ACEOF

# create fileb standard
rm -f t/fileb-standard.dat && cat <<_ACEOF > t/fileb-standard.dat
000001 20200101 50.00
000002 20200101 60.00
000003 20200101 70.00
000004 20200101 80.00
000005 20200101 90.00
000006 20200101 100.00
000007 20200101 110.00
000008 20200101 120.00
000009 20200101 130.00
000010 20200101 140.00
000011 20200102 200.00
_ACEOF

# create expected file
rm -f t/expected.dat && cat <<_ACEOF > t/expected.dat
000000 20200102             200.00
000001 20200101             510.00
000002 20200101              60.00
000003 20200101              70.00
000004 20200101              80.00
000005 20200101             230.00
000006 20200101             250.00
000007 20200101             270.00
000008 20200101             290.00
000009 20200101             310.00
000010 20200101             520.00
000011 20200102             200.00
_ACEOF

./synchrofiles.py --filea t/filea-standard.dat --fileb t/fileb-standard.dat --filec t/result.dat >> /dev/null || { echo 'program FAILED'; exit 1; }
diff t/expected.dat t/result.dat || { echo 'test FAILED'; exit 1; } && echo 'test OK'
rm -f t/filea-standard.dat t/fileb-standard.dat t/expected.dat t/result.dat
