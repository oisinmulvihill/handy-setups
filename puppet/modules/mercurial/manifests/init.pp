# Recovered from:
#
# https://bitbucket.org/oherrala/puppet/raw/2e1536894052/mercurial/manifests/init.pp
#
# Oisin Mulvihil
# 2012-10-14.
#

# Install Mercurial.
#
class mercurial::client {

    package { "mercurial":
        ensure => installed,
    }

}

class mercurial {
    include mercurial::client
}

# Clone repository.
#
# === Parameters
#
#   $name:
#       Destination directory.
#   $source:
#       Source URL.
#   $ensure:
#       Revision. Defaults to tip.
#
define mercurial::clone($source, $ensure="tip") {

    exec { "hg-clone-${name}":
        path    => "/bin:/usr/bin:/sbin:/usr/sbin",
        command => "hg -y clone -r ${ensure} ${source} ${name}",
        creates => $name,
        require => Package["mercurial"],
    }

    exec { "hg-pull-${name}":
        path    => "/bin:/usr/bin:/sbin:/usr/sbin",
        cwd     => $name,
        command => "hg -y pull -u -r ${ensure}",
        onlyif  => $ensure ? {
            "tip"   => "hg -y in",
            default => "test $(hg -y id -i) != ${ensure}",
        },
        require => Exec["hg-clone-${name}"],
    }

}