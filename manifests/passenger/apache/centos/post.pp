class rvm::passenger::apache::centos::post(
  $ruby_version,
  $version,
  $rvm_prefix = '/usr/local/',
  $mininstances = '1',
  $maxpoolsize = '6',
  $poolidletime = '300',
  $maxinstancesperapp = '0',
  $spawnmethod = 'smart-lv2',
  $gempath,
  $binpath
) {
  exec {
    'passenger-install-apache2-module':
      command   => "${rvm::passenger::apache::binpath}rvm ${rvm::passenger::apache::ruby_version} exec passenger-install-apache2-module -a",
      creates   => "${rvm::passenger::apache::gempath}/passenger-${rvm::passenger::apache::version}/ext/apache2/mod_passenger.so",
      logoutput => 'on_failure',
      require   => [Rvm_gem['passenger'], Package['httpd','httpd-devel','mod_ssl']];
  }

  exec{
      'create /etc/httpd/conf.d/passenger.conf':
      command => "${rvm::passenger::apache::binpath}rvm ${rvm::passenger::apache::ruby_version} exec passenger-install-apache2-module --snippet > /etc/httpd/conf.d/passenger.conf",
      creates => '/etc/httpd/conf.d/passenger.conf',
      logoutput => 'on_failure',
      require => Exec['passenger-install-apache2-module'];
  }
}
