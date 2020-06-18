#!/bin/sh

################################################################
## This section is
## Based on https://github.com/sickp/docker-alpine-sshd
################################################################
# generate host keys if not present
ssh-keygen -A
# do not detach (-D), log to stderr (-e), passthrough other arguments
/usr/sbin/sshd -D -e "$@" &

################################################################
## This section is
## Based on https://github.com/svenihoney/docker-wetty-alpine
################################################################
if [ "x${BASE}" == "x" ]; then
  BASE="/"
fi

# Move to wetty app folder
cd /app
if [ "x${REMOTE_SSH_SERVER}" == "x" ]; then
  # Login mode, no SSH_SERVER
  npm start -- -p ${WETTY_PORT}
else
  # SSH connect mode
  #
  # Preload key
  mkdir ~/.ssh && \
  ssh-keyscan -H -p ${REMOTE_SSH_PORT} ${REMOTE_SSH_SERVER} > ~/.ssh/known_hosts

  cmd="npm start -- -p ${WETTY_PORT} --sshhost ${REMOTE_SSH_SERVER} --sshport ${REMOTE_SSH_PORT} --base ${BASE}" 
  if ! [ "x${REMOTE_SSH_USER}" == "x" ]; then
    cmd="${cmd} --sshuser ${REMOTE_SSH_USER}"
  fi
  if ! [ "x${SSH_AUTH}" == "x" ]; then
    cmd="${cmd} --sshauth ${SSH_AUTH}"
  fi
  if ! [ "x${SSH_KEY}" == "x" ]; then
    cmd="${cmd} --sshkey ${SSH_KEY}"
  fi
  su -c "${cmd}" #node
fi