#!/usr/bin/env bash

# Read the environment we are registering for and the Gitlab token
ENV=$1
TOKEN=$2

sudo gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "${TOKEN}" \
  --executor "docker" \
  --docker-image alpine:latest \
  --docker-privileged \
  --description "${ENV}-runner" \
  --tag-list "${ENV}" \
  --run-untagged="false" \
  --locked="false" \
  --access-level="not_protected"
