# == Class: gitlist
#
# Installs gitlist web interface. This works quite will with the
# eshamow-gitolite module to build a full git stack. Module expects that
# puppetlabs-apache is applied to the target node.
#
# === Parameters
#
# [*webdir_path*]
#   Directory for web server root. Defaults to '/var/www/html'
# [*webuser_name*]
#   Username under which the webserver user runs. Defaults to 'apache'
# [*webgroup_name*]
#   Group name under which the webserver user runs. Defaults to 'apache'
# [*restart_service*]
#   Boolean. If set to 'true' the module will restart the service specified
#   in webservice_name. Defaults to false.
# [*webservice_name*]
#   Name of the service to kick if restart_service is set to true. Defaults to
#   'httpd.'
# [*apache_confdir*]
#   Directory into which we can drop configuration snippet for webserver.
#   Defaults to '/etc/httpd/conf.d'
# [*git_client_path*]
#   Path to git binary. Defaults to '/usr/bin/git.'
# [*default_branch*]
#   Default branch to check for each repo. Defaults to 'master.'
# [*repositories_path*]
#   Path of parent directory for git repositories. Defaults to
#   '/home/git/repositories.'
# [*debug*]
#   Passed through to gitlist config, sets debug mode to true. Defaults to
#   'false.'
# [*cache*]
#   Turn on caching. Defaults to 'true.'
# [*download_source*]
#   Boolean to indicate whether or not the source tarball should be downloaded.
#   Defaults to false.
# [*source_location*]
#   Location of a tarball containing the gitlist code. Can be any format
#   accepted by the nanliu-staging module. Defaults to
#   'https://s3.amazonaws.com/gitlist/gitlist-0.4.0.tar.gz'
#
# === Examples
#
#  class { gitlist:
#    restart_service => true,
#    webservice_name => 'apache',
#    source_location => '/var/www/gitlist-0.4.2.tar.gz',
#  }
#
# === Authors
#
# Eric Shamow <eric@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs
#
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
