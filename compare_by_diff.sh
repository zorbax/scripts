#!/bin/bash
local=$1
exported=$2

echo -e "\n" >> local_VS_exportedDiff.log
echo "Comparing $local and $exported" >> local_VS_exportedDiff.log

ls $local | sort > local
ls $exported | sort > exported

sizel=`wc -l local | cut -d " " -f1`
sizee=`wc -l exported | cut -d " " -f1`

sizediff=$(($sizee-$sizel))

echo "exported size is local size + $(($sizee - $sizel))" >> local_VS_exportedDiff.log

if [ "$sizel" -gt 1 ]
then
{
	if [ $sizediff -ge 0 ]
	then
	{
		echo "Comparing file by file" >> local_VS_exportedDiff.log
		comm -1 -2 local exported | awk -v l=$local -v e=$exported '{print "diff -q "l"/"$1" "e"/"$1}' > compare.sh
		chmod +x compare.sh
		./compare.sh >> localal_VS_exportedDiff.log
	}
	else echo "Number of exported files is less than number of local files. Export may not be completed" >> local_VS_exportedDiff.log
	fi
}
else echo "ALERT: local files no longer exist" >> local_VS_exportedDiff.log
fi

rm local exported compare.sh

echo "DONE" >> local_VS_exportedDiff.log
