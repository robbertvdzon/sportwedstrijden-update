#!/bin/bash

export APPLICATION_VERSION_FILE="http://www.vdzon.com/_jar/msw-portlet-version.php"
export APPLICATION_NAME="Mijnsportwedstrijden"


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
	logger "Update for  $APPLICATION_NAME found! Restarting application"
	cd /workspace/sportwedstrijden-deployment
	docker-compose stop
	cd /workspace/
	rm -rf /workspace/sportwedstrijden-deployment
	git clone https://github.com/robbertvdzon/sportwedstrijden-deployment.git
	cd /workspace/sportwedstrijden-deployment
	chmod a+x *.sh
	./download_and_start.sh
else 	
	logger "No update for $APPLICATION_NAME found"
fi
