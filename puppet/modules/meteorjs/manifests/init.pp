# Install meteor from the web ready to start development.
#
# Reference:
#  * http://docs.meteor.com/
#
# Oisin Mulvihill
# 2013-01-02
#

class meteorjs {

    exec {
        "meteor-curl-install":
            command => "su -c 'curl https://install.meteor.com | /bin/sh'",
            path => "/bin:/usr/bin:/usr/local/bin",
    }

}