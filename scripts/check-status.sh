#!/bin/bash

# Make sure we call this from the same folder as the status file
QGSTATUS=$( cat ./status.txt )

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