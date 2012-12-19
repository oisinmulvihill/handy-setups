#

class ipy_notepad {

    $require = [
        Class["python_development"],
    ]

    package {
        [
            'python-pandas', 'python-matplotlib', 'ipython',
            'ipython-qtconsole', 'ipython-notebook', 'ipython-doc'
        ]:
            ensure => present;
    }

    file {
        "ipynotepad":
            path => "/etc/supervisor/conf.d/ipynotepad.conf",
            mode => 644,
            content => template("ipy_notepad/ipynotepad.conf.erb"),
            ensure => file;
    }

    exec {
        "reload-config":
            command => "sudo supervisorctl reload ; echo > /dev/null",
            path => "/bin:/usr/bin:/usr/local/bin",
    }

    Class["python_development"] ->
    Package['python-pandas'] -> Package['python-matplotlib'] ->
    Package['ipython'] -> Package['ipython-qtconsole'] ->
    Package['ipython-notebook'] -> Package['ipython-doc'] ->
    File["ipynotepad"] -> Exec["reload-config"]
}