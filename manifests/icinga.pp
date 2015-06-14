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
}
