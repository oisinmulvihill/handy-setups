#

class ipy_notepad {

    include nginx

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

    # Proxy the default localhost:10080 port. Connecting to the hostname
    # notepad.example.com will connect to localhost:10080.
    nginx::resource::upstream {'notepad-proxy':
        ensure  => present,
        members => [
            'localhost:10080',
        ],
    }
    nginx::resource::vhost {"notepad.example.com":
        ensure => present,
        proxy => "http://notepad-proxy",
    }
    exec {
        "reload-nginx":
            command => "sudo /etc/init.d/nginx reload",
            path => "/bin:/usr/bin:/usr/local/bin",
    }

    Class["python_development"] ->
    Package['python-pandas'] -> Package['python-matplotlib'] ->
    Package['ipython'] -> Package['ipython-qtconsole'] ->
    Package['ipython-notebook'] -> Package['ipython-doc'] ->
    File["ipynotepad"] -> Exec["reload-config"] ->
    Nginx::Resource::Upstream['notepad-proxy'] ->
    Nginx::Resource::Vhost['notepad.example.com'] ->
    Exec["reload-nginx"]

}