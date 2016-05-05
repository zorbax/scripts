#!/bin/bash

mocatpath=`grep 'MOCAT_dir' MOCAT.cfg | cut -f 2 -d":" | sed 's/ //'`   
if [ -e $mocatpath/ext/usearch/usearch ]; then                          
  echo "*** Usearch INSTALLED ***"                                        
  chmod u+x $mocatpath/ext/usearch/usearch                                

  MOCAT.pl -sf sample -rtf &&                  
  MOCAT.pl -sf sample -s mock_community_ref &&
  MOCAT.pl -sf sample -f mock_community_ref &&
  MOCAT.pl -sf sample -p mock_community_ref &&
  MOCAT.pl -sf sample -sff mock_adapters &&
  MOCAT.pl -sf sample -s mock_community_ref -r mock_adapters &&
  MOCAT.pl -sf sample -f mock_community_ref -r mock_adapters &&
  MOCAT.pl -sf sample -p mock_community_ref -r mock_adapters &&
  MOCAT.pl -sf sample -a -r mock_adapters &&
  MOCAT.pl -sf sample -gp assembly -r mock_adapters &&
  MOCAT.pl -sf sample -ss  &&
  echo DONE

else
  echo "Usearch not found"
  echo "$mocatpath/ext/usearch/usearch"
  echo "Please install it"
fi


