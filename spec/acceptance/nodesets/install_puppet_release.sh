#!/bin/bash

puppet=${BEAKER_PUPPET_COLLECTION:-puppet7}

dnf -y install http://yum.puppet.com/"$puppet"-release-fedora-34.noarch.rpm
dnf -y install puppet-agent
