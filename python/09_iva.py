#!/usr/bin/env python3

import sys
from pathlib import Path


def sat(subtotal, kind='iva'):
    iva = subtotal * 0.16
    total = subtotal + iva
    retiva = iva * 2 / 3
    retisr = subtotal * 0.10
    end = total + retiva + retisr

    iva_types = ['iva', 'ret']
    if kind not in iva_types:
        msg = f'{kind} argument is not' \
              f'an accepted IVA type\n' \
              f"arguments = ['iva', 'ret']"
        raise ValueError(msg)

    if kind == 'iva':
        print(f"Con IVA\n"
              f"====================\n"
              f"Subtotal  > {subtotal:.2f}\n"
              f"IVA (16%) > {iva:.2f}\n"
              f"Total  > {total:.2f}")
    else:
        print(f"Con Retención\n"
              f"====================\n"
              f"Subtotal  > {subtotal:.2f}\n"
              f"IVA ret   > {retiva:.2f}\n"
              f"ISR ret   > {retisr:.2f}\n"
              f"Total     > {end:.2f}")


def main():
    if len(sys.argv) < 2:
        print(f"\nUsage: ./{Path(__file__).name} subtotal ['iva', 'ret']\n"
              f"Default iva\n",
              file=sys.stderr)
        sys.exit(1)
    if len(sys.argv) < 3:
        sat(float(sys.argv[1]))
    else:
        sat(float(sys.argv[1]), kind=str(sys.argv[2]))


if __name__ == '__main__':
    main()
