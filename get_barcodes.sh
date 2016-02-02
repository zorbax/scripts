#!/bin/bash
iontor_linker='CCATCTCATCCCTGCGTGTCTCCGACTCAG'
cur_dir=`pwd`
sample=`ls $cur_dir | grep -E '*.fna'`
touch fasting_map_combine
echo "#SampleID	BarcodeSequence	LinkerPrimerSequence	InputFileName	Description" > fasting_map_combine

for i in $sample;
	do
		#echo "What is the name of treatment?"
		#echo
		#echo
		#read treatment
		#echo
		echo "----------------------------------------"
		echo "----------------------------------------"
    	echo "Please enter the sample name for $i"
   		read name
		echo "----------------------------------------"
		echo "----------------------------------------"
    	echo "Please enter the description for $i"
   		read description
		echo "----------------------------------------"
		echo "----------------------------------------"
		echo "Please select yor V3-341 barcodes for $i"
		echo "----------------------------------------"
		echo "----------------------------------------"
		PS3='Number?:'
		options=("F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10"  \
				 "F11" "F12" "F13" "F14" "F15" "F16" "F17" "F18" "F19" "F20" \
				 "F21" "F22" "F23" "F24" "F25" "F26" "F27" "F28" "F29" "F30" \
				 "F31" "F32" "F33" "F34" "F35" "F36" "F37" "F38" "F39" "F40" \
				 "F41" "F42" "F43" "F44" "F45" "F46" "F47" "F48" "F49" "F50" \
                 "None" "Quit")

		select opt in "${options[@]}"
		do
		    case $opt in
				"F1")
		            echo "$name	GATCTGCGATCC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F2")
		            echo "$name	CAGCTCATCAGC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F3")
		            echo "$name	CAAACAACAGCT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F4")
		            echo "$name	GCAACACCATCC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F5")
		            echo "$name	GCGATATATCGC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F6")
		            echo "$name	CGAGCAATCCTA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F7")
		            echo "$name	AGTCGTGCACAT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F8")
		            echo "$name	GTATCTGCGCGT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F9")
		            echo "$name	CGAGGGAAAGTC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F10")
		            echo "$name	CAAATTCGGGAT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F11")
		            echo "$name	AGATTGACCAAC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F12")
		            echo "$name	AGTTACGAGCTA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F13")
		            echo "$name	GCATATGCACTG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F14")
		            echo "$name	CAACTCCCGTGA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F15")
		            echo "$name	TTGCGTTAGCAG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F16")
		            echo "$name	TACGAGCCCTAA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F17")
		            echo "$name	CACTACGCTAGA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F18")
		            echo "$name	TGCAGTCCTCGA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F19")
		            echo "$name	ACCATAGCTCCG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F20")
		            echo "$name	TGGACATCTCTT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F21")
		            echo "$name	GAACACTTTGGA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F22")
		            echo "$name	GAGCCATCTGTA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F23")
		            echo "$name	TTGGGTACACGT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F24")
		            echo "$name	AAGGCGCTCCTT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F25")
		            echo "$name	TAATACGGATCG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F26")
		            echo "$name	TCGGAATTAGAC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F27")
		            echo "$name	TGTGAATTCGGA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F28")
		            echo "$name	CATTCGTGGCGT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F29")
		            echo "$name	AACGCACGCTAG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F30")
		            echo "$name	ACACTGTTCATG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F31")
		            echo "$name	ACCAGACGATGC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F32")
		            echo "$name	ACGCTCATGGAT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F33")
		            echo "$name	ACTCACGGTATG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F34")
		            echo "$name	AGACCGTCAGAC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F35")
		            echo "$name	AGCACGAGCCTA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F36")
		            echo "$name	ACAGACCACTCA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F37")
		            echo "$name	ACCAGCGACTAG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F38")
		            echo "$name	ACGGATCGTCAG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F39")
		            echo "$name	AGCTTGACAGCT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F40")
		            echo "$name	AACTGTGCGTAC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F41")
		            echo "$name	ACCGCAGAGTCA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F42")
		            echo "$name	ACGGTGAGTGTC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F43")
		            echo "$name	ACTCGATTCGAT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F44")
		            echo "$name	AGACTGCGTACT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F45")
		            echo "$name	AGCAGTCGCGAT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F46")
		            echo "$name	AGGACGCACTGT	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F47")
		            echo "$name	AAGAGATGTCGA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F48")
		            echo "$name	ACAGCAGTGGTC	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F49")
		            echo "$name	ACGTACTCAGTG	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "F50")
		            echo "$name	ACTCGCACAGGA	$iontor_linker	$i	$description" >> fasting_map_combine
					break
		            ;;
		        "Quit")
		            break
		            ;;
		        *) echo invalid option;;
		    esac
		done
done
