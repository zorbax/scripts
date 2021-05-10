#!/usr/bin/env python3
import sys
import os
import random
import string


def main():

    if len(sys.argv) != 2:
        print(f"\nUsage: ./{os.path.basename(sys.argv[0])} n_passwords\n",
              file=sys.stderr)
        sys.exit(1)

    def random_password(length=4):
        prefix = "atg"
        code = string.ascii_letters + string.digits[1:]
        rndn = ''.join(random.choice(code) for x in range(length))

        while not any(char.isdigit() for char in rndn):
            rndn = ''.join(random.choice(code) for y in range(length))

        return prefix + rndn

    for i in range(int(sys.argv[1])):
        print(random_password())


if __name__ == '__main__':
    main()
