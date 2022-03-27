#!/bin/bash

# Example queries to grab relevant info from
# the issues table and copy to a file we can use.

# Option No. 1
# Default here will just create array of issues ordered
# by their severity.
# Example JSON output

# [
#   {
#     "severity":"MAJOR",
#     "tags":
#     "accessibility,wcag2-a",
#     "line":2,
#     "message":"Add \"lang\" and/or \"xml:lang\" attributes to this \"<html>\" element",
#     "path":"app/index.html"
#   }
# ]

psql -U sonar -d sonar <<- EOF
COPY (
  SELECT
    array_to_json(array_agg(row_to_json(t)))
  FROM (
    SELECT
      issues.severity,
      issues.tags,
      issues.line,
      issues.message,
      components.long_name AS path
    FROM
      issues
    INNER JOIN
      components
    ON
      issues.component_uuid = components.uuid
    ORDER BY
      issues.severity
  ) t
) to '/tmp/dump.json';
EOF

# Option No. 2
# Will create object grouping issues by path
# Example JSON output
# [
#   {
#     "path":"app/index.html",
#     "issues": [
#       {
#         "severity":"MAJOR",
#         "message":
#         "Add \\"lang\\" and/or \\"xml:lang\\" attributes to this \\"<html>\\" element",
#         "line":2,
#         "tags":
#         "accessibility,wcag2-a"
#       }
#     ]
#   }
# ]
#
# COPY
#   (SELECT
#     array_to_json(array_agg(row_to_json(t)))
#   FROM (
#     SELECT long_name AS path,
#       (
#         SELECT
#           array_to_json(array_agg(row_to_json(d)))
#         FROM (
#           SELECT severity, message, line, tags
#           FROM issues
#           WHERE component_uuid=components.uuid
#           ORDER BY severity
#         ) d
#       ) AS issues
#     FROM components
#     WHERE EXISTS
#       (
#         SELECT component_uuid
#         FROM issues
#         WHERE component_uuid = components.uuid
#       )
#   ) t
# ) to '/tmp/dump.json';
