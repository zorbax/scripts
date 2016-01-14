#!/usr/bin/python

name = 'Beatriz'
age = 28 #not a lie
height = 1.75 #meters
weight = 60 #kilograms
eyes = 'brown'
teeth = 'white'
hair = 'black'

print "Let's talk about %s." % name
print "She's %.2f meters tall." % height
print "She's %d kilograms heavy." % weight
print "Actually that's not too heavy."
print "She's got %s eyes and %s hair." % (eyes, hair)
print "His teeth are usually %s depending on the cofee." % teeth

print "If I add %d, %.2f, and %d I get %.2f" % (
    age, height, weight, age + height + weight)
