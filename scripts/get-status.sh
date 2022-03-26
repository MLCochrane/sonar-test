#!/bin/bash

# Lightly modified from https://www.apriorit.com/dev-blog/748-qa-integrating-quality-control-into-cicd
# Just fetches the project status from the API and then returns an exit code to set the CircleCI job status
PROJECTKEY="my:project"

QGSTATUS=`curl -s -u admin:admin http://localhost:9000/api/qualitygates/project_status?projectKey=$PROJECTKEY | jq '.projectStatus.status' | tr -d '"'`

echo $QGSTATUS
if [ "$QGSTATUS" = "OK" ]
then
  echo "Status is OK"
  exit 0
else
  echo "Status was not OK - review issues artifact for more details."
  exit 1
fi