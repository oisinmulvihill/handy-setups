#
# Do a python2.7 from an alternative PPA into the lucid base box which will not
# clobber any existing system python install.
#
# Ref:
#  * http://askubuntu.com/questions/101591/how-do-i-install-python-2-7-2-on-10-04
#
# Oisin Mulvihill
# 2012-09-02
#
class py27_deadsnakes_ppa {
    package {
        [
            # used for compiling python from source. kept for reference:
            #"libreadline5-dev","libncursesw5-dev", "libssl-dev",
            #"libsqlite3-dev", "tk-dev", "libgdbm-dev", "libc6-dev",
            #"libbz2-dev"
            #
            "python-software-properties",
        ]:
            ensure => installed;
    }

    Package["python-software-properties"] ->

    exec { "deadsnakes-add-ppa":
        command => "add-apt-repository ppa:fkrull/deadsnakes",
        path => "/usr/local/bin:/usr/bin:/bin",
    }

    Exec["deadsnakes-add-ppa"] ->

    exec { "deadsnakes-apt-get-update":
        command => "apt-get update",
        path => "/usr/local/bin:/usr/bin:/bin",
    }

    Exec["deadsnakes-apt-get-update"] ->

    exec { "deadnsakes-py27-install":
        tries => 3,
        try_sleep => 2,
        command => "su - -c \"apt-get -y --force-yes install python2.7 python2.7-dev \"",
        path => "/usr/local/bin:/usr/bin:/bin",
    }

    Exec["deadnsakes-py27-install"] ->

    exec { "deadnsakes-setuptools-install":
        command => "su - -c 'apt-get -y --force-yes install python2.7-distribute-deadsnakes'",
        path => "/usr/local/bin:/usr/bin:/bin",
        #creates => "/usr/local/bin/easy_install-2.7",
    }

    Exec["deadnsakes-setuptools-install"] ->

    exec { "easy-install-27-pip":
        command => "easy_install-2.7 pip",
        path => "/usr/local/bin:/usr/bin:/bin",
        #creates => "/usr/local/bin/pip-2.7",
    }

    exec { "easy-install-27-virtualenvwrapper":
        command => "easy_install-2.7 virtualenvwrapper",
        path => "/usr/local/bin:/usr/bin:/bin",
        #creates => "/usr/local/bin/virtualenvwrapper.sh",
    }

    Exec["easy-install-27-pip"] -> Exec["easy-install-27-virtualenvwrapper"]
}
