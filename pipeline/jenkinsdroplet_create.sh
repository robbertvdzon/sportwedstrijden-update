#!/bin/bash

export API_KEY=`cat digitalocean-api-key`
export DROPLET_NAME="mijnsportwedstrijden.pipeline"
export SNAPSHOT_NAME="mijnsportwedstrijden.pipeline.img.v1"

# log all output to syyslog
exec 1> >(logger -s -t $(basename $0)) 2>&1

# check if there is already a pipeline droplet running
export DROPLET_ID=`curl -s -X GET -H 'Content-Type: application/json' -H 'Authorization: Bearer '$API_KEY'' "https://api.digitalocean.com/v2/droplets?page=1&per_page=99"  | jq '[.droplets[]]' | jq '.[] | select (.name == "'$DROPLET_NAME'")' | jq '.id'`
if [ ! -z "$DROPLET_ID" ]; then
    echo "Pipeline is already running under ID $DROPLET_ID"
    exit 1
fi  

# find snapshot id
export SNAPSHOT_ID=`curl -s -X GET -H 'Content-Type: application/json' -H 'Authorization: Bearer '$API_KEY'' "https://api.digitalocean.com/v2/images?page=1&per_page=99" | jq '[.images[]]' | jq '.[] | select (.name == "'$SNAPSHOT_NAME'")' | jq '.id'`
if [ -z "$SNAPSHOT_ID" ]; then
    echo "Pipeline snapshot is not found"
    exit 1
fi  
echo "Snapshot found under ID:$SNAPSHOT_ID"


# create droplet
curl -s -X POST -H 'Content-Type: application/json' -H 'Authorization: Bearer '$API_KEY'' -d '{  "name": "'$DROPLET_NAME'",  "region": "ams3",  "size": "512mb",  "image": "'$SNAPSHOT_ID'",  "ssh_keys": null,  "backups": false,  "ipv6": true,  "user_data": null,  "private_networking": null}' "https://api.digitalocean.com/v2/droplets" | jq '.'
