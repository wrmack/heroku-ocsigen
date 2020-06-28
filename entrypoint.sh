#!/bin/bash

# Environment variables

# When deploying to Heroku (comment out for local use)
# $PORT is supplied by Heroku
export USER="$(whoami)"
export GROUP=dyno

# When testing locally (comment out for Heroku)
# export PORT=8080
# export USER=opam
# export GROUP=opam

# Substitute $PORT, $USER and $GROUP variables in ocsigen.conf.template and write to ocsigen.conf
envsubst < /home/opam/ocsigen/ocsigen.conf.template > /home/opam/ocsigen/ocsigen.conf

exec "$@"