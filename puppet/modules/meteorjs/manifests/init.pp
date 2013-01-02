# Install meteor from the web ready to start development.
#
# Reference:
#  * http://docs.meteor.com/
#
# Oisin Mulvihill
# 2013-01-02
#

class meteorjs {

    include nginx

    exec {
        "meteor-curl-install":
            command => "su -c 'curl https://install.meteor.com | /bin/sh'",
            path => "/bin:/usr/bin:/usr/local/bin",
            # If this is present it won't rerun the web based install:
            creates => "/usr/bin/meteor"
    }

    # Proxy the default localhost:3000 meteor port. Connecting to the hostname
    # meteor.example.com will connect to localhost:3000 (if its running).
    nginx::resource::upstream {'meteor-proxy':
        ensure  => present,
        members => [
            'localhost:3000',
        ],
    }
    nginx::resource::vhost {"meteor.example.com":
        ensure => present,
        proxy => "http://meteor-proxy",
    }
    exec {
        "reload-nginx":
            command => "sudo /etc/init.d/nginx reload",
            path => "/bin:/usr/bin:/usr/local/bin",
    }

    Exec["meteor-curl-install"] ->
    Nginx::Resource::Upstream['meteor-proxy'] ->
    Nginx::Resource::Vhost['meteor.example.com'] ->
    Exec["reload-nginx"]

}