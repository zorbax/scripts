#!/usr/bin/env python3

import sys

class desgloseIVA (object):

    def __init__(self):
        self.iva = 0.16
        self.isr = 0.10
        self.retiva = 2.0 / 3.0
        #self.retiva = 0.10667
        self.factor = 1.0 + self.iva - self.isr - self.iva * self.retiva

    def retencion(self, cant):
        self.xini = cant / self.factor
        self.xiva = self.xini * self.iva
        self.subtot = self.xini + self.xiva
        self.xretiva = self.xiva * self.retiva
        self.xretisr = self.xini * self.isr
        self.xfin = self.xini + self.xiva - self.xretiva - self.xretisr
        return self

    def __str__(self):
        print("Importe : %10.2f" % self.xini)
        print("IVA (%2.0f %%): %10.2f" % (self.iva * 100.0, self.xiva))
        print("Subtotal: %10.2f" % self.subtot)
        print("Retención IVA : %10.2f" % self.xretiva)
        print("Retención ISR : %10.2f" % self.xretisr)
        return("Total : %10.2f" % self.xfin)


if __name__ == '__main__':
    if len(sys.argv) == 2:
        x = float(sys.argv[1])
        des = desgloseIVA()
        print(des.retencion(x))
