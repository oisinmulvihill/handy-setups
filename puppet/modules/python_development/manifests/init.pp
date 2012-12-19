#
# Oisin Mulvihill
# 2012-08-21
#

class python_development {
    $require = [
        Class["user_settings"],
    ]

    package {
        "python": ensure => installed;
        "python-dev": ensure => installed;
        "python-setuptools": ensure => installed;
        "python-virtualenv": ensure => installed;
    }

    exec {"install-pip":
        command => "easy_install pip",
        path => "/usr/local/bin:/usr/bin:/bin",
        require => [
            Package["python"],
            Package["python-dev"],
            Package["python-setuptools"],
            Package["python-virtualenv"],
        ],
        unless => "which pip",
    }

    exec {"install-virtualenvwrapper":
        command => "easy_install -ZU virtualenvwrapper",
        path => "/usr/local/bin:/usr/bin:/bin",
        require => [
            Package["python"],
            Package["python-dev"],
            Package["python-setuptools"],
            Package["python-virtualenv"],
        ],
        unless => "which virtualenvwrapper.sh",
    }

    Exec["install-pip"] -> Exec["install-virtualenvwrapper"]

    # file {
    #     "pydistutils-cfg":
    #         path => "/home/vagrant/.pydistutils.cfg",
    #         mode => 644,
    #         content => template("python_development/pydistutils.cfg.erb"),
    #         ensure => file,
    #         replace => true,
    #         owner => "vagrant",
    #         group => "vagrant";
    # }

    # exec {"pyenv-setup":
    #     command => "virtualenv --clear /home/vagrant/pyenv",
    #     path => "/usr/local/bin:/usr/bin:/bin",
    #     creates => "/home/vagrant/pyenv",
    #     require => [
    #         Package["build-essential"],
    #         Package["python"],
    #         Package["python-dev"],
    #         Package["python-setuptools"],
    #         Package["python-virtualenv"],
    #     ],
    #     user => "vagrant",
    # }

    #File["pydistutils-cfg"] -> Exec["pyenv-setup"]

}
