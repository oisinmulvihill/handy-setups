# Provision a machine with what is needed to run bookingsys.
#
# Oisin Mulvihill
# 2012-08-23
#
group { "puppet":
    ensure => "present",
}

exec {"apt-get-update":
    command => "apt-get update",
    path => "/bin:/usr/bin:/usr/local/bin",
}

package {
    ["curl"]:
        ensure => installed,
}

Group["puppet"] -> Exec["apt-get-update"] -> Package["curl"] ->


# Absolutely state the order of execution:
#
Class["user_settings"] ->
Class["rcs_deps"] ->
Class["devtools"] ->
Class["python_development"] ->
Class["supervisor"] ->
Class["ipy_notepad"]

# What modules to include on this machine:
#
# the include order doesn't matter. The important thing is that an included
# module is included in the above order of install.
#
include user_settings
include rcs_deps
include devtools
include python_development
include supervisor
include ipy_notepad
