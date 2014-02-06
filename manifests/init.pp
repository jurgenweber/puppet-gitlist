# == Class: gitlist
#
# Full description of class gitlist here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { gitlist:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
#NOTE: REQUIRES APACHE+PHP ALREADY CONFIGURED
class gitlist (
  $webdir          = $gitlist::params::webdir,
  $webuser         = $gitlist::params::webuser,
  $webgroup        = $gitlist::params::webgroup,
  $restart_apache  = false,
  $apache_service  = $gitlist::params::apache_service,
  $apache_confdir  = $gitlist::params::apache_confdir,
  $client          = $gitlist::params::client,
  $default_branch  = $gitlist::params::default_branch,
  $repositories    = $gitlist::params::repositories,
  $debug           = $gitlist::params::debug,
  $cache           = $gitlist::params::cache,
  $download        = true,
  $source_location = 'https://s3.amazonaws.com/gitlist/gitlist-0.4.0.tar.gz',
) inherits gitlist::params {
  if $source_location == undef {
    if $download == false {
      fail('gitlist: If download is set to false, you must set $source_location.')
    }
  }

  $apache_notify = $restart_apache ? {
    true  => Service[$apache_service],
    default => undef,
  }
  staging::file { 'gitlist.tar.gz':
    source => $source_location,
  } ~>
  staging::extract { 'gitlist.tar.gz':
    target => "${webdir}/",
    creates => "${webdir}/gitlist"
  } ->
  file { "${webdir}/gitlist":
    ensure  => directory,
    recurse => true,
    owner   => $webuser,
    group   => $webgroup,
  }
  file { "${webdir}/gitlist/cache":
    ensure => directory,
    owner  => $webuser,
    group  => $webgroup,
    mode   => '0750',
  }
  file { "${webdir}/gitlist/config.ini":
    content => template('gitlist/config.ini.erb'),
    owner   => $webuser,
    group   => $webgroup,
  }
  file { "${webdir}/gitlist/.htaccess":
    content => template('gitlist/htaccess.erb'),
  }
  file { "${apache_confdir}/gitlist.conf":
    ensure => file,
    owner  => $webuser,
    content => template('gitlist/gitlist.conf.erb'),
    group  => $webgroup,
    mode   => '0750',
    notify => $apache_notify,
  }
}
