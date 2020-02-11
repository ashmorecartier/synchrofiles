#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
    Simple and trivial program generating lines in stdout
        each lines contain :
            an incremental id (int)
            an account (int)
            an amount in range 0. +100000 (double)
            separator is blank

    standalone program
    ------------------

    parameters
    ---------
    num: int
        number of line in stdout (a positive integer)
'''

import sys
import random
import argparse

def main(num=50000):

    '''
        Trivial program generating randomly an incremental Id, an account and an amount
    '''

    random.seed()

    for i in range(num):

        date = '20200101'

        mnt = random.uniform(0., 100000.)

        print('{0:06d}'.format(i), date, '{0:15.2f}'.format(mnt))

    return 0

if __name__ == '__main__':

    # argparse: standard command line parser
    parser = argparse.ArgumentParser(description='Generate randomly in stdout\
        an incremental Id, an account and an amount NUM times')
    parser.add_argument('--num', default=50000, type=int, help='num must be a positive integer')
    args = parser.parse_args()

    status = 1
    if args.num > 0:
        status = main(args.num)
    else:
        print('num args null or negative')
        print('program stopped')

    sys.exit(status)
