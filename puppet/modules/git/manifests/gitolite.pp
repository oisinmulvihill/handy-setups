# Class: git::gitolite
#
# This class installs gitolite on debian hosts
#
#
# Requires:
#  - Class[git]
#
#
class git::gitolite {
  include git

  package { "gitolite":
    ensure => present,
  }
}
