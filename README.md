#modulename

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with [eshamow-gitlist]](#setup)
    * [What [eshamow-gitlist] affects](#what-[eshamow-gitlist]-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with [eshamow-gitlist]](#beginning-with-[eshamow-gitlist])
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

Module to install/manage gitlist. Intended to pair with eshamow-gitolite for full management of git stack. Expects Apache+PHP installed and configured on target node.

##Module Description

Module to install/manage gitlist. Intended to pair with eshamow-gitolite for full management of git stack. Expects Apache+PHP installed and configured on target node.

Currently supports RHEL or CentOS 6 and Debian 6 only. Future targets:

RHEL 5
Debian 7
Ubuntu 12.04

##Setup

###What [eshamow-gitlist] affects

* By default, downloads gitlist package
* Uses nanliu-staging to expand this archive into a parameterized path
* Drops conf files in Apache fragments dir and minimal .htaccess in gitlist directory

###Setup Requirements

* Expects 'git' binary to be installed/available. puppetlabs-git suffices for most systems.
* Expects puppetlabs-apache and nanliu-staging
* By default, intended to work with eshamow-gitolite. Implementation with other systems may vary
* Nothing about this other than convention makes it Apache-only - would be easy to put in conditionals/support/templates for other webservers
  
###Beginning with [eshamow-gitlist]  

Classify node with gitlist.

##Limitations

RHEL or CentOS 6 only
