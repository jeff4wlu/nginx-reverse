
#!/bin/bash

i=0

docker-machine ls |while read line
do
	if((i>0)) 
	then
		name=`echo $line|cut -d " " -f1`
		docker-machine rm $name -f
		echo $name
	fi
	((i++))
done



