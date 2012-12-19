# install everything required to be a git client
class git {

  include git::params

  package { $git::params::packages:
    ensure => present,
  }
}
