#!/bin/bash

puppet=${BEAKER_PUPPET_COLLECTION:-puppet8}

dnf -y install http://yum.puppet.com/"$puppet"-release-fedora-36.noarch.rpm
dnf -y install puppet-agent
