#!/bin/bash

# Lightly modified from
# https://www.apriorit.com/dev-blog/748-qa-integrating-quality-control-into-cicd.
# Just fetches the project status from the API and then returns an exit code to
# set the CircleCI job status


# This will run INSIDE the server container and not as a normal job on the host
# container since we can't expose arbitrary ports in CircleCI. That is why we
# have apk and wget - they're already in the image and reduces the number of
# extra steps we need to take.

PROJECTKEY="my:project"

QGSTATUS=`wget -qO- http://admin:admin@server:9000/api/qualitygates/project_status?projectKey=$PROJECTKEY | jq '.projectStatus.status' | tr -d '"'`

# Saving to file so we can throw exit code _after_ we get the issues file from
# our DB container. Throwing the exit code here means an error stops the
# CircleCI job and we can't see what the issues we need to fix are.
echo "$QGSTATUS" >> ./status.txt