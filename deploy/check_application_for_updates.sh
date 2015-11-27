#!/bin/bash

export APPLICATION_VERSION_FILE="http://www.vdzon.com/_jar/download.php?file=lastversion.txt"
export APPLICATION_NAME="Mijnsportwedstrijden"

cd /workspace/sportwedstrijden-update/deploy

# log all output to syyslog
exec 1> >(logger -s -t $(basename $0)) 2>&1

# check for updates
touch lastversion
echo `curl -s -X GET $APPLICATION_VERSION_FILE` > newversion
diff lastversion newversion
comp_value=$?
cp newversion lastversion
if [ $comp_value -eq 1 ]
then
	echo "Update for  $APPLICATION_NAME found! Restarting application"
	cd /workspace/sportwedstrijden-deployment
	/usr/local/bin/docker-compose stop
	/usr/local/bin/docker-compose kill
	cd /workspace/
	rm -rf /workspace/sportwedstrijden-deployment
	git clone https://github.com/robbertvdzon/sportwedstrijden-deployment.git
	cd /workspace/sportwedstrijden-deployment
	chmod a+x *.sh
	./download_and_start.sh
else 	
	echo "No update for $APPLICATION_NAME found"
fi
