# Install meteor from the web ready to start development.
#
#  * http://docs.meteor.com/
#
# Oisin Mulvihill
# 2013-01-02
#

class meteorjs {

    exec {
        "meteor-curl-install":
            command => "curl https://install.meteor.com | /bin/sh",
            path => "/bin:/usr/bin:/usr/local/bin",
    }

}