#!/usr/bin/env bash

echo "testserver \
  ansible_host=`terraform output vm_public_ip` " > playbooks/hosts
