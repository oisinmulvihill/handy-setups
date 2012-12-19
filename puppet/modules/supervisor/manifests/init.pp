#
# Install supervisord used to manage processes we can run as daemon.
#
# Oisin Mulvihill
# 2012-09-05
#
class supervisor {

    package {
        "supervisor": ensure => installed;
    }

    include rcs_deps
    include user_settings
    #include py27_deadsnakes_ppa
    include python_development

    Class["user_settings"] -> Class["rcs_deps"] -> Class["python_development"] ->
    Package["supervisor"] ->

    file {
        "supervisor-conf":
            path => "/etc/supervisor/supervisord.conf",
            mode => 644,
            content => template("supervisor/supervisord.conf"),
            replace => true,
            ensure => file;
    }

    File["supervisor-conf"] ->

    # Make a user editable place for supervisor.d:
    exec {"user-confd-dir":
        command => "su vagrant -c 'mkdir -p src/supervisor/conf.d' ; sudo chown -R vagrant: src/supervisor",
        cwd => "/home/vagrant",
        path => "/bin:/usr/bin:/usr/local/bin",
        creates => "/home/vagrant/src/supervisor/conf.d"
    }

    exec {"user-logs-dir":
        command => "su vagrant -c 'mkdir -p src/supervisor/logs'",
        cwd => "/home/vagrant",
        path => "/bin:/usr/bin:/usr/local/bin",
        creates => "/home/vagrant/src/supervisor/logs",
    }

    service {
        "supervisor": ensure => true;
    }

    Exec["user-confd-dir"] -> Exec["user-logs-dir"] ~> Service["supervisor"]
}