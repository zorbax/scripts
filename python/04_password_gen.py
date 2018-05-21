#!/usr/bin/python3
import sys
import os
import random


def main():

    if len(sys.argv) != 2:
        print('Usage: ./%s passwords_number ' % os.path.basename(
                                           sys.argv[0]), file=sys.stderr)
        sys.exit(1)

    def genpsswd():
        alpha = "abcdefghijklmnopqrstuvwxyz123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        psswd = "Senasica"

        for i in range(3):
            index = random.randrange(len(alpha))
            psswd += alpha[index]
        return psswd

    for i in range(int(sys.argv[1])):
        print(genpsswd())


if __name__ == '__main__':
    main()
