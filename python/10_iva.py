#!/usr/bin/env python3

import sys
import os


def main():
    if len(sys.argv) != 2:
        print('\nUsage: ./%s mount\n' % os.path.basename(
            sys.argv[0]), file=sys.stderr)
        sys.exit(1)

    def sat(mount):
        factor = 1 + 0.16 - 0.10 - 0.16 * 2 / 3
        init = mount / factor
        iva = init * 0.16
        subtotal = init + iva
        retiva = iva * 2 / 3
        retisr = init * 0.10
        end = init + iva - retiva - retisr

        print('Mount      >%10.2f' % init)
        print('IVA (%d%%)  >%10.2f' % (16, iva))
        print('Subtotal   >%10.2f' % subtotal)
        print('IVA ret    >%10.2f' % retiva)
        print('ISR ret    >%10.2f' % retisr)
        print('Total      >%10.2f' % end)

    sat(int(sys.argv[1]))


if __name__ == '__main__':
    main()
