#sportwedstrijden-update
Scrip to automatically start a pipeline at digital ocean when the git project for sportwedstrijden is updated and a script that checks when a new sportwedstrijden binary is updated and redeploys the application on this machine.
Also, a script is created to automatically destroy the pipeline at midnight.

#Intall update services on server
```
mkdir /workspace
git clone https://github.com/robbertvdzon/sportwedstrijden-update.git
chmod a+x /workspace/sportwedstrijden-update/pipeline/*.sh
chmod a+x /workspace/sportwedstrijden-update/deploy/*.sh
echo "00 00 * * * root /workspace/sportwedstrijden-update/pipeline/jenkinsdroplet_delete.sh &" > /etc/cron.d/destroy_pipeline
echo "* * * * * root /workspace/sportwedstrijden-update/pipeline/check_git_for_updates.sh &" > /etc/cron.d/check_pipeline
echo "* * * * * root /workspace/sportwedstrijden-update/deploy/check_application_for_updates.sh &" > /etc/cron.d/check_msw_deploy
```

To be able to create a new pipeline droplet at digital ocean, we need a digital ocean API key.
this key must be placed in the file pipeline/digitalocean-api-key
```
echo YOUR_API_KEY > /workspace/sportwedstrijden-update/pipeline/digitalocean-api-key
```

if jq is not installed, then that must be installed as well:
```
apt-get install jq
```

The update scripts are run every minute and log their output at /var/log/syslog and at midnight the pipeline droplet is destroyed.
