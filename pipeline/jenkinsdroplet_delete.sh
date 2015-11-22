#!/bin/bash

export API_KEY=`cat digitalocean-api-key`
export DROPLET_NAME="mijnsportwedstrijden.pipeline"

# log all output to syyslog
exec 1> >(logger -s -t $(basename $0)) 2>&1

export DROPLET_ID=`curl -s -X GET -H 'Content-Type: application/json' -H 'Authorization: Bearer '$API_KEY'' "https://api.digitalocean.com/v2/droplets?page=1&per_page=99" | jq '[.droplets[]]' | jq '.[] | select (.name == "'$DROPLET_NAME'")' | jq '.id'`
curl -s -X DELETE -H 'Content-Type: application/json' -H 'Authorization: Bearer '$API_KEY'' "https://api.digitalocean.com/v2/droplets/$DROPLET_ID"  | jq '.'
