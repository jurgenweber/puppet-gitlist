class gitlist::params {
  $webdir = '/var/www/html'
  $webuser = 'apache'
  $webgroup = 'apache'
  $client = '/usr/bin/git'
  $default_branch = 'master'
  $repositories = '/home/git/repositories'
  $debug = false
  $cache = true
  $apache_service = 'httpd'
  $apache_confdir = '/etc/httpd/conf.d'
}
