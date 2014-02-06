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
  $webdir_path       = $gitlist::params::webdir_path,
  $webuser_name      = $gitlist::params::webuser_name,
  $webgroup_name     = $gitlist::params::webgroup_name,
  $restart_service   = $gitlist::params::restart_service,
  $webservice_name   = $gitlist::params::webservice_name,
  $apache_confdir    = $gitlist::params::apache_confdir,
  $git_client_path   = $gitlist::params::git_client_path,
  $default_branch    = $gitlist::params::default_branch,
  $repositories_path = $gitlist::params::repositories_path,
  $debug             = $gitlist::params::debug,
  $cache             = $gitlist::params::cache,
  $download_source   = $gitlist::params::download_source,
  $source_location   = $gitlist::params::source_location
) inherits gitlist::params {
  if $source_location == undef and $download_source == false {
    fail('gitlist: If download is set to false, you must set $source_location.')
  }

  $apache_notify = $restart_service ? {
    true  => Service[$webservice_name],
    default => undef,
  }

  staging::file { 'gitlist.tar.gz':
    source => $source_location,
  } ~>
  staging::extract { 'gitlist.tar.gz':
    target  => "${webdir_path}/",
    creates => "${webdir_path}/gitlist"
  } ->
  file { "${webdir_path}/gitlist":
    ensure  => directory,
    recurse => true,
    owner   => $webuser_name,
    group   => $webgroup_name,
  }
  file { "${webdir_path}/gitlist/cache":
    ensure => directory,
    owner  => $webuser_name,
    group  => $webgroup_name,
    mode   => '0750',
  }
  file { "${webdir_path}/gitlist/config.ini":
    content => template('gitlist/config.ini.erb'),
    owner   => $webuser_name,
    group   => $webgroup_name,
  }
  file { "${webdir_path}/gitlist/.htaccess":
    content => template('gitlist/htaccess.erb'),
  }
  file { "${apache_confdir}/gitlist.conf":
    ensure  => file,
    owner   => $webuser_name,
    content => template('gitlist/gitlist.conf.erb'),
    group   => $webgroup_name,
    mode    => '0750',
    notify  => $apache_notify,
  }
}
