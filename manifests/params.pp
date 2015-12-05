#
#
#
class gitlist::params {
  $restart_service   = false
  $git_client_path   = '/usr/bin/git'
  $default_branch    = 'master'
  $repositories_path = '/home/git/repositories'
  $debug             = false
  $cache             = true
  $download_source   = true
  $source_location   = 'https://s3.amazonaws.com/gitlist/gitlist-0.4.0.tar.gz'

  case $::osfamily {
    'redhat': {
      $webdir_path     = '/var/www/html'
      $webuser_name    = 'apache'
      $webgroup_name   = 'apache'
      $webservice_name = 'httpd'
      $apache_confdir  = '/etc/httpd/conf.d'
    }
    'debian': {
      $webdir_path     = '/var/www'
      $webuser_name    = 'www-data'
      $webgroup_name   = 'www-data'
      $webservice_name = 'apache2'
      $apache_confdir  = '/etc/apache2/conf.d'
    }
    'default': {
      fail("osfamily ${::osfamily} is not supported by eshamow-gitlist.")
    }
  }
}
