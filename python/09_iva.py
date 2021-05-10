#!/usr/bin/env python3

import sys
import os


def sat(mount):
    iva = mount * 0.16
    subtotal = mount + iva
    retiva = iva * 2 / 3
    retisr = mount * 0.10
    end = subtotal + retiva + retisr

    print(f"Cantidad  > {mount:.2f}")
    print(f"IVA (16%) > {iva:.2f}")
    print(f"Subtotal  > {subtotal:.2f}")
    print(f"IVA ret   > {retiva:.2f}")
    print(f"ISR ret   > {retisr:.2f}")
    print(f"Total     > {end:.2f}")


def main():
    if len(sys.argv) != 2:
        print(f"\nUsage: ./{os.path.basename(sys.argv[0])} amount\n",
              file=sys.stderr)
        sys.exit(1)
    sat(float(sys.argv[1]))


if __name__ == '__main__':
    main()
