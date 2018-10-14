#!/bin/sh

hostname=fingers.today
domain=fingers.today
sitepath=/data/0f/sites/${domain}/lib/

if [ -z "$1" ]; then
  echo "Usage: deploy <gitobject>"
else
  revision_for_log=$(git rev-parse $1)
  git archive -o deploy.tar.gz ${revision_for_log} &&
  scp deploy.tar.gz ${hostname}:${sitepath} &&
  rm deploy.tar.gz &&
  ssh -t ${hostname} "
    cd ${sitepath} &&
    tar -zxvf deploy.tar.gz &&
    rm deploy.tar.gz &&
    0f ${domain} &&
    echo $(date): ${revision_for_log} >> deploy.log
  "
fi
