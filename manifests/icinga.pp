class icinga::profile {

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
