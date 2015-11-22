#!/bin/bash

export GIT_REPO="https://github.com/robbertvdzon/sportwedstrijden.git"
export APPLICATION_NAME="Mijnsportwedstrijden"


# log all output to syyslog
exec 1> >(logger -s -t $(basename $0)) 2>&1

touch last_git_info
git ls-remote $GIT_REPO > new_git_info
diff last_git_info new_git_info
comp_value=$?
if [ $comp_value -eq 1 ]
then
	echo "Git update for $APPLICATION_NAME found, starting pipeline"
	/workspace/sportwedstrijden-update/pipeline/jenkinsdroplet_create.sh
else 	
	echo "No git update for $APPLICATION_NAME found"
fi
cp new_git_info last_git_info
