#!/bin/bash

cd $(dirname $0);
BASE=$(dirname $PWD);
HUBOT=$(which hubot);
HUBOT_DIR=$(basename $PWD);

#echo "BASE=${BASE}";
#echo "HUBOT=${HUBOT}";
#echo "HUBOT_DIR=${HUBOT_DIR}";

if [ "${HUBOT}" == "" ] ; then
  echo "Installing hubot (will prompt for password)..."
  sudo npm install -g hubot coffee-script
fi

cd ..
if [ ! -e "${HUBOT_DIR}/bin" ] ; then
  hubot --create "${HUBOT_DIR}"
  cd "${HUBOT_DIR}" 

  if [ ! -e "node_modules" ] ; then
    npm install hubot-irc --save && npm install
  fi
  cd ..
fi

export HUBOT_IRC_SERVER=irc.freenode.net # this is the url for irc server
export HUBOT_IRC_ROOMS="#intere-build" 
export HUBOT_IRC_NICK="robotnik" 
export HUBOT_IRC_UNFLOOD="true" 
export HUBOT_JENKINS_URL=http://localhost:8081/jenkins
#export HUBOT_JENKINS_AUTH=<user>:<passwd> 
export HUBOT_AUTH_ADMIN=intere

running=$(ps -aef|grep -i hubot|grep -v grep|grep irc|awk '{print $2}');

if [ "${running}" == "" ] ; then 
  cd "${HUBOT_DIR}"
  bin/hubot --adapter irc &
else
  echo "Hubot is already running: PID=${running}"
fi

