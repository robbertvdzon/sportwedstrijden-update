#!/bin/bash
cd /workspace/sportwedstrijden/docker
while :
do
	echo "check git"
	git pull
	cp /tmp/checksum /tmp/checksum_prev
	sha1sum /workspace/sportwedstrijden/docker/portlet_data/mijnsportwedstrijden-0.0.1-SNAPSHOT.jar  > /tmp/checksum
	diff /tmp/checksum /tmp/checksum_prev
	comp_value=$?
	if [ $comp_value -eq 1 ]
	then
		echo "changed"
		docker-compose stop
		docker-compose build
		docker-compose up -d
	fi
	
	sleep 10
done