#!/usr/bin/python
from __future__ import print_function
import random
import sys

def genpsswd():
	alpha = "abcdefghijklmnopqrstuvwxyz123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	psswd = "senasica"

	for i in range(3):
		index = random.randrange(len(alpha))
		psswd += alpha[index]
	return psswd

for i in range(int(sys.argv[1])):
	print(genpsswd())
