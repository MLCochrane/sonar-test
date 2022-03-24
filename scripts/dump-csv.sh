#!/bin/bash
psql -U sonar -d sonar -c "COPY (SELECT severity, message FROM issues) to '/tmp/dump.csv'"

