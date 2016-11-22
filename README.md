# zram

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with zram](#setup)
    * [What zram affects](#what-zram-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with zram](#beginning-with-zram)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module configures zram swap using udev rules (no init scripts or systemd
units needed).

## Module Description

Want to know more about zram?  Read the
[Linux kernel documentation](https://www.kernel.org/doc/Documentation/blockdev/zram.txt).

## Setup

### What zram affects

Creates the following files:

* /lib/udev/zram
* /etc/udev/rules.d/01-zram.rules
* /etc/modprobe.d/zram.conf

Finally, it loads the zram module.

### Setup Requirements

This module requires [puppetlabs-stdlib](https://forge.puppet.com/puppetlabs/stdlib)
and [camptocamp-kmod](https://forge.puppet.com/camptocamp/kmod).

### Beginning with zram

Make sure you are using a kernel that includes the zram module.

## Usage

    class { 'zram': }

## Reference

This module accepts the following parameters:

* `numdevices`
Number of zram devices.  Defaults to the number of processors
($::processorcount).

* `disksize`
Size of zram devices.  Defaults to half of memory divided by numdevices.

## Limitations

This module has been tested on Ubuntu 16.04 and Debian Jessie (Raspbian).

## Development

Send me a pull request on GitHub.
