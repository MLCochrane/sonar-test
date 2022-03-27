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
# We just want an exit code based on the project status - WARN vs. ERROR is less
# a concern here.
if [ "$QGSTATUS" = "OK" ]
then
  echo "Status is OK"
  exit 0
else
  echo "Status was not OK - review issues artifact for more details."
  exit 1
fi