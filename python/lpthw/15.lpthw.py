#!/usr/bin/python
from sys import argv

script, filename = argv

txt = open(filename)

print "Here's your file %r:" % filename
print ""
print txt.read()

print "Type the file name again:"
print ""

file_again = raw_input("> ")

txt_again = open(file_again)

print ""
print txt_again.read()

