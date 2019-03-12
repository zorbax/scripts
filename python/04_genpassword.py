#!/usr/bin/python3
import sys
import os
import random
import string


def main():

    if len(sys.argv) != 2:
        print('\nUsage: ./%s n_passwords\n' % os.path.basename(
                                           sys.argv[0]), file=sys.stderr)
        sys.exit(1)

    def random_password(length = 4):
        prefix = "S3nasica"
        code = string.ascii_letters + string.digits[1:]
        rndn = ''.join(random.choice(code) for i in range(length))
 
        while not any(char.isdigit() for char in rndn):
            rndn = ''.join(random.choice(code) for i in range(length))

        return prefix + rndn

    for i in range(int(sys.argv[1])):
        print(random_password())


if __name__ == '__main__':
    main()
