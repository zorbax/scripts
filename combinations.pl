#!/usr/bin/perl
use strict;
use warnings;

use Algorithm::Combinatorics 'variations_with_repetition';

#my @nucl = qw/ A G C T /;

#my @dna = variations_with_repetition(\@nucl, 24);

#print "@$_\n" for @dna;

my @data = qw( a g c t );

# scalar context gives an iterator
  my $iter = variations_with_repetition(\@data, 24);
    while (my $p = $iter->next) {
    my $result = join '', values $p;
    #       print $result,'.';
        print "$result\n";
    }

