#
# My settings to aid me in using ubuntu:
#
class user_settings {

    package {
        "vim": ensure => installed;
        "bash": ensure => installed;
        "screen": ensure => installed;
    }

    file {
        "vimrc":
            path => "/home/vagrant/.vimrc",
            mode => 644,
            content => template("user_settings/vimrc.erb"),
            ensure => file,
            owner => "vagrant",
            group => "vagrant";

        "bash_profile":
            path => "/home/vagrant/.bash_profile",
            mode => 644,
            content => template("user_settings/bash_profile.erb"),
            ensure => file,
            owner => "vagrant",
            group => "vagrant";

        "bashrc":
            path => "/home/vagrant/.bashrc",
            mode => 644,
            content => template("user_settings/bashrc.erb"),
            ensure => file,
            owner => "vagrant",
            group => "vagrant";

        "set-env":
            path => "/etc/environment",
            mode => 644,
            content => template("user_settings/environment.erb"),
            ensure => file,
            owner => "vagrant",
            group => "vagrant";

        "vcprompt-copy":
            path => "/bin/vcprompt",
            mode => 755,
            source => "/vagrant/files/vcprompt/vcprompt",
            ensure => file;
    }

    # exec {"install-vcprompt"
    #     command => "curl -OsL https://github.com/djl/vcprompt/raw/master/bin/vcprompt && chmod 755 vcprompt",
    #     cwd => "/usr/bin",
    #     path => "/usr/local/bin:/usr/bin:/bin",
    #     require => Package["curl"],
    #     unless => "which vcprompt",
    # }

    # Exec["install-vcprompt"] ->

    # This simulates a login which triggers the .bashrc copying and set up
    # of .ssh, git, mercurial and other settings. This allows code to be
    # checked out by later modules as the user running vagrant on the 'host'
    # machine.
    #
    exec { "first-login-setup":
        command => "su vagrant -c \"bash -c 'source /home/vagrant/.bashrc && normal_login'\"",
        path => "/bin:/usr/bin:/sbin:/usr/sbin",
        tries => 4,
        try_sleep => 2,
        cwd => "/home/vagrant",
        logoutput => true,
    }

    Package["vim"] -> Package["bash"] -> Package["screen"] ->
    File["vimrc"] -> File["bash_profile"] -> File["bashrc"] -> File["vcprompt-copy"] ->
    File["set-env"] -> Exec["first-login-setup"]
}