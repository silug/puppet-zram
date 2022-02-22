# zram

#### Table of Contents

- [zram](#zram)
      - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Module Description](#module-description)
  - [Setup](#setup)
    - [What zram affects](#what-zram-affects)
    - [Setup Requirements](#setup-requirements)
    - [Beginning with zram](#beginning-with-zram)
  - [Usage](#usage)
  - [Reference](#reference)
  - [Limitations](#limitations)
  - [Development](#development)

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
and [puppet-kmod](https://forge.puppet.com/puppet/kmod).

### Beginning with zram

Make sure you are using a kernel that includes the zram module.

## Usage

    class { 'zram': }

## Reference

The `zram` class accepts the following parameters:

* `numdevices`
Number of zram devices.  Defaults to the number of processors
(`$facts['processorcount']`).

* `disksize`
Size of zram devices.  Defaults to half of memory divided by `numdevices`.

See [`REFERENCE.md`](REFERENCE.md) for more details.

## Limitations

This module has been tested on a number of systems.  (See
[`metadata.json`](metadata.json) for a full list.)  It *should* work on any
Linux distribution that includes the zram kernel module.

## Development

Send me a pull request on [GitHub](https://github.com/silug/puppet-zram).
