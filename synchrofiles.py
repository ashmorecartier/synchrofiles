#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
    Demonstration program matching two files with a key

    standalone program
    ------------------
    output produces :
        filec: a file given in parameter which contain the result.
        The format is the fileb format
        each lines of file contain :
            a keyb (the matching key)
            a date (the date of the last operation applied)
            an amount (the amount of the last balance)
            separator : blank
    example : 000001 20200101 8533.45398608017

        In this particular case:
            if keya == keyb amountc = amounta + amountb
            if keya not in fileb we create keya in filec
            we keep a keyb unchanged if not in filea
            globally a M x N is reduced to 1 in filec with sum.

    parameters
    ---------
    filea: a file or stdin (the operation file)
        each lines of file contain :
            an id
            a keya (the matching key)
            a date (the date of operation)
            an amount in range -10000. +10000 (the amount of operation to apply)
            separator : blank
    example : 0 000001 20200110 8532.45398608017

    fileb: a file given in parameter (the balance file)
        each lines of file contain :
            a keyb (the matching key)
            a date (the date of the last operation applied)
            an amount (the amount of the last balance)
            separator : blank
    example : 000001 20200101 1.0

'''

import sys
import argparse
from datetime import datetime, date, MINYEAR

def main(streama, streamb, streamc):

    """
        Aim is to update streamb by streama using a common key.
        Results will be in streamc, its format is that of streamb
    """

    # init global var
    # datas from streama
    newida = ''
    newkeya = ''
    newdatea = date(MINYEAR, 1, 1)
    newmnta = ''
    # datas from streama
    oldida = ''
    oldkeya = ''
    olddatea = date(MINYEAR, 1, 1)
    oldmnta = ''
    # datas from streamb
    newkeyb = ''
    newdateb = date(MINYEAR, 1, 1)
    newmntb = ''
    # datas from streamb
    oldkeyb = ''
    olddateb = date(MINYEAR, 1, 1)
    oldmntb = ''

    # last mouvement for filea init at True
    lmvkeya = True
    # first mouvement for filea, first mouvement is the previous last mouvement
    fmvkeya = True

    # last mouvement for fileb init at True
    lmvkeyb = True
    # first mouvement for fileb, first mouvement is the previous last mouvement
    fmvkeyb = True

    # end of file
    newfeofa = False
    newfeofb = False
    enda = False
    endb = False

    # authorization to read files
    autha = True
    authb = True

    # a sum of amount for filea and fileb
    cummnta = 0.0
    cummntb = 0.0

    # total record read
    nbenra = 0
    nbenrb = 0
    nbenrout = 0
    nbloop = 0

    # first read streama
    l_ina = streama.readline()
    if not l_ina:
        streamc.write('**************\n')
        streamc.write('*  StreamA   *\n')
        streamc.write('* Empty File *\n')
        streamc.write('**************\n')
        newfeofa = True
        autha = False
        enda = True
    else:
        newida, newkeya, newdatea, newmnta = l_ina.split()
        nbenra += 1
    #fi

    # first read streamb
    l_inb = streamb.readline()
    if not l_inb:
        streamc.write('**************\n')
        streamc.write('*  StreamB   *\n')
        streamc.write('* Empty File *\n')
        streamc.write('**************\n')
        newfeofb = True
        authb = False
        endb = True
    else:
        newkeyb, newdateb, newmntb = l_inb.split()
        nbenrb += 1
    #fi

    # loop
    while not (enda and endb):

        nbloop += 1

        if autha:
            # datas save
            oldida = newida
            oldkeya = newkeya
            olddatea = newdatea
            oldmnta = newmnta

            # a check to verify we don't read too much
            if newfeofa:
                print('error filea')
                print('too many read')
                print('program aborted')
                sys.exit(1)
            #fi

            # second read
            l_ina = streama.readline()
            if not l_ina:
                newfeofa = True
            else:
                newida, newkeya, newdatea, newmnta = l_ina.split()
                nbenra += 1
            #fi

            # a check of right order
            if newkeya < oldkeya:
                print('error filea')
                print('bad sorted key')
                print('newkeya :', newkeya, 'oldkeya :', oldkeya)
                print('at :', nbenra)
                print('program aborted')
                sys.exit(1)
            #fi

            # a check of right order
            if newkeya == oldkeya and newdatea < olddatea:
                print('error filea')
                print('bad sorted key')
                print('newkeya :', newkeya, 'oldkeya :', oldkeya)
                print('newdatea :', newdatea, 'olddatea :', olddatea)
                print('at :', nbenra)
                print('program aborted')
                sys.exit(1)
            #fi

            # rupt permutation
            fmvkeya = lmvkeya
            lmvkeya = False

            # rupt calc key
            if (oldkeya != newkeya) or newfeofa:
                lmvkeya = True
            #fi

            # on first mouvement init for cummnta
            if fmvkeya:
                cummnta = 0.0
            #fi

            # current record
            cummnta += float(oldmnta)

            # reading invalidated filea
            autha = False
        #fi

        if authb:
            # datas save
            oldkeyb = newkeyb
            olddateb = newdateb
            oldmntb = newmntb

            # a check to verify we don't read too much
            if newfeofb:
                print('error fileab')
                print('too many read')
                print('program aborted')
                sys.exit(1)
            #fi

            # second read
            l_inb = streamb.readline()
            if not l_inb:
                newfeofb = True
            else:
                newkeyb, newdateb, newmntb = l_inb.split()
                nbenrb += 1
            #fi

            # a check of right order
            if newkeyb < oldkeyb:
                print('error fileb')
                print('bad sorted key')
                print('newkeyb :', newkeyb, 'oldkeyb :', oldkeyb)
                print('at :', nbenrb)
                print('program aborted')
                sys.exit(1)
            #fi

            # a check of right order
            if newkeyb == oldkeyb and newdateb < olddateb:
                print('error fileb')
                print('bad sorted key')
                print('newkeyb :', newkeyb, 'oldkeyb :', oldkeyb)
                print('newdateb :', newdateb, 'olddateb :', olddateb)
                print('at :', nbenrb)
                print('program aborted')
                sys.exit(1)
            #fi

            # rupt permutation
            fmvkeyb = lmvkeyb
            lmvkeyb = False

            # rupt calc key
            if (oldkeyb != newkeyb) or newfeofb:
                lmvkeyb = True
            #fi

            # on first mouvement init for cummntb
            if fmvkeyb:
                cummntb = 0.0
            #fi

            # current record
            cummntb += float(oldmntb)

            # reading invalidated filea
            authb = False
        #fi

        # at this point, we have two lines for each stream old one and new one

        # loop until lvm for filea
        if not lmvkeya:
            autha = True
            continue
        #fi

        # loop until lvm for fileb
        if not lmvkeyb:
            authb = True
            continue
        #fi

        # here we are in lvm for filea and fileb simultaneously
        # if key matched we generate a sum record
        if oldkeya == oldkeyb:
            s_d = '{0:s}'.format(oldkeyb) + ' '
            if olddatea >= olddateb:
                s_d += '{0:s}'.format(olddatea) + ' '
            else:
                s_d += '{0:s}'.format(olddateb) + ' '
            #fi
            s_d += '{0:>18.2f}'.format(cummnta + cummntb)
            streamc.write(s_d+'\n')
            nbenrout += 1
            autha = not newfeofa
            authb = not newfeofb
            enda = newfeofa
            endb = newfeofb
            continue
        #fi

        # keya < keyb
        if oldkeya < oldkeyb and not enda:
            s_d = '{0:s}'.format(oldkeya) + ' '
            s_d += '{0:s}'.format(olddatea) + ' '
            s_d += '{0:>18.2f}'.format(cummnta)
            streamc.write(s_d+'\n')
            nbenrout += 1
            autha = not newfeofa
            enda = newfeofa
            continue
        #fi

        # keya > keyb
        if oldkeya > oldkeyb and not endb:
            s_d = '{0:s}'.format(oldkeyb) + ' '
            s_d += '{0:s}'.format(olddateb) + ' '
            s_d += '{0:>18.2f}'.format(cummntb)
            streamc.write(s_d+'\n')
            nbenrout += 1
            authb = not newfeofb
            endb = newfeofb
            continue
        #fi

        # filea finished
        if enda:
            s_d = '{0:s}'.format(oldkeyb) + ' '
            s_d += '{0:s}'.format(olddateb) + ' '
            s_d += '{0:>18.2f}'.format(cummntb)
            streamc.write(s_d+'\n')
            nbenrout += 1
            authb = not newfeofb
            endb = newfeofb
            continue
        #fi

        # fileb finished
        if endb:
            s_d = '{0:s}'.format(oldkeya) + ' '
            s_d += '{0:s}'.format(olddatea) + ' '
            s_d += '{0:>18.2f}'.format(cummnta)
            streamc.write(s_d+'\n')
            nbenrout += 1
            autha = not newfeofa
            enda = newfeofa
            continue
        #fi

    #endloop

    print()
    print('Total records in filea     : {0:>15d}'.format(nbenra))
    print('Total records in fileb     : {0:>15d}'.format(nbenrb))
    print('Total records output       : {0:>15d}'.format(nbenrout))
    print('Total loops                : {0:>15d}'.format(nbloop))
    return 0

if __name__ == '__main__':

    # argparse: standard command line parser
    parser = argparse.ArgumentParser(description='Update Fileb with Filea, Result Filec')
    parser.add_argument('--filea', default='fica.txt')
    parser.add_argument('--fileb', default='ficb.txt')
    parser.add_argument('--filec', default='result.txt')
    args = parser.parse_args()

    status = 1

    print('Program started')
    nowstart = datetime.now()
    print('Start Date                 : ', nowstart.today())
    print()

    # try opening (r) filea or stdin
    if args.filea == '-':
        filea = sys.stdin
    else:
        try:
            filea = open(args.filea, 'r')
        except IOError:
            filea.close()
            print(args.filea, ': No such file')
            print('program aborted')
            sys.exit(status)
        #endtry
    #fi

    # try opening (r) fileb
    try:
        fileb = open(args.fileb, 'r')
    except IOError:
        fileb.close()
        if filea != sys.stdin:
            filea.close()
        #fi
        print(args.fileb, ': No such file')
        print('program aborted')
        sys.exit(status)
    #endtry

    # try opening (w) result filec
    try:
        filec = open(args.filec, 'w')
    except IOError:
        filec.close()
        fileb.close()
        if filea != sys.stdin:
            filea.close()
        #fi
        print(args.filec, ': unable to open filec !!!')
        print('program aborted')
        sys.exit(status)
    #endtry

    status = main(streama=filea, streamb=fileb, streamc=filec)
    filec.close()
    fileb.close()
    if filea != sys.stdin:
        filea.close()
    #fi

    nowend = datetime.now()
    print()
    print('End Date                   : ', nowend.today())
    print('Duration                   : ', nowend - nowstart)
    print('Job terminated')
    sys.exit(status)
#fi
