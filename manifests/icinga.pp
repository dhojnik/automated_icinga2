class icinga::profile {

mysql::db { 'icinga2_data':
  user     => 'icinga2',
  password => 'gargamel007',
  host     => 'localhost',
  grant    => ['ALL'],
}

mysql::db { 'icinga2_web':
  user     => 'icinga2',
  password => 'gargamel007',
  host     => 'localhost',
  grant    => ['ALL'],
}

mysql::db { 'icinga2_ido':
  user     => 'icinga2',
  password => 'gargamel007',
  host     => 'localhost',
  grant    => ['ALL'],
}

class { 'apache':
  default_mods        => true,
  default_confd_files => true,
  mpm_module          => prefork,
}  

apache::mod { 'rewrite': }

class {'::apache::mod::php':
   content => '
AddHandler php5-script .php
AddType text/html .php',
}

/*
apache::custom_config { 'icingaweb2':
  content => template('icingaweb2/apache2.conf.erb'),
}
*/

class { 'icinga2::server':
  server_db_type => 'mysql',
  db_host => 'localhost',
  db_port => '3306',
  db_name => 'icinga2_data',
  db_user => 'icinga2',
  db_password => 'gargamel007',
  server_enabled_features  => ['checker','notification', 'compatlog', 'graphite', 'mainlog', 'perfdata', 'command', 'syslog', 'ido-mysql', 'statusdata', 'livestatus'],
}

icinga2::object::idomysqlconnection { 'mysql_connection':
   target_dir => '/etc/icinga2/features-enabled',
   target_file_name => 'ido-mysql.conf',
   host             => '127.0.0.1',
   port             => '3306',
   user             => 'icinga2',
   password         => 'gargamel007',
   database         => 'icinga2_data',
   categories => ['DbCatConfig', 'DbCatState', 'DbCatAcknowledgement', 'DbCatComment', 'DbCatDowntime', 'DbCatEventHandler' ],
}

class { 'icingaweb2':
   install_method => 'package',
   ido_type       => 'mysql',
   ido_db_user    => 'icinga2',
   ido_db_pass    => 'gargamel007',
   ido_db_host    => 'localhost',
   ido_db_port    => '3306',
   web_db_name    => 'icinga2_web',
   web_db_host    => 'localhost',
   web_db_pass    => 'gargamel007',
   web_db_port    => '3306',
   web_root       => '/usr/share/icingaweb2/',
   manage_apache_vhost => true,
   admin_permissions   => '*',
   admin_users         => 'icingaadmin',
}

/*
class { 'icingaweb2::mod::nagvis':
   nagvis_url => 'http://player.dev-dojo.local/render?',
}
*/
 
class { 'icingaweb2::mod::graphite':
   graphite_base_url => 'http://player.dev-dojo.local/nagvis/',
}

}
