class profiles::mysql {

  include mysql::server

  create_resources('mysql::db', hiera_hash('databases'))
}
