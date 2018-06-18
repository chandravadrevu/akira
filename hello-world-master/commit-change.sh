#!/bin/bash
#
# commit-change.sh
#
set -x

git add . --all 

git commit -S -m="Hello AWX" 
git push 

tower-cli workflow_job launch \
  --workflow-job-template="Dev Deployment" \
  --extra-vars="instance_tag=house001 instance_type=t2.medium"
