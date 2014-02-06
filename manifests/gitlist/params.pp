class gitlist::params {
  $webdir_path       = '/var/www/html'
  $webuser_name      = 'apache'
  $webgroup_name     = 'apache'
  $restart_service   = false
  $webservice_name   = 'httpd'
  $apache_confdir    = '/etc/httpd/conf.d'
  $git_client_path   = '/usr/bin/git'
  $default_branchi   = 'master'
  $repositories_path = '/home/git/repositories'
  $debug             = false
  $cache             = true
  $download_source   = true
  $source_location   = 'https://s3.amazonaws.com/gitlist/gitlist-0.4.0.tar.gz'
}
