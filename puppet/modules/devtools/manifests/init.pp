# This provides the compiler and other tools modules such as python_development
# depend on.
#
# Oisin Mulvihill
# 2012-09-02
#

class devtools {
    package {
        "build-essential": ensure => installed;
    }
}
