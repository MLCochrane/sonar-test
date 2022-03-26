#!/bin/bash

# Example query to grab relevant info from
# the issues table and copy to a file we can use.

psql -U sonar -d sonar -c "COPY (SELECT severity, message FROM issues) to '/tmp/dump.csv'"
