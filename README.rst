Handy Vagrant + Puppet Development Environment Configuration
============================================================

.. contents::


Introduction
------------

In August 2012 I decided use virtual machines entirely for my development
environments. Previously I would set up a project's dependancies directly
on my Mac laptop. This can prove quite painful as most of the dependancies
compile best on Linux. This choice proved itself in other ways, when I changed
laptop. I was able to get back to being productive in a very short period of
time on a new machine. I've since extended this approach to all machines I
work on.

This project sets up (provisions) a blank Ubuntu machines with "technology
stacks" I'm developing with or interested in. I'm slowly going to move in set
ups I'm using which I can make public. This should help others interested in
Puppet and Vagrant. It maybe even inspire them to improve my puppet knowledge.

Vagrant is great for managing virtual machine images. I use it in addition to
Puppet which provisions (sets up) dependancies and project specifics. Puppet
modules and manifest files provides the technical "how to" need to create and
re-create a specific set up. More generally, this approach can allow a team of
developers to share a common environment. Which can save countless man hours of
set up. The automated machine set up allows you to concentrate on development
over the annoying business of environment set up.


Prerequisits
------------

VirtualBox
~~~~~~~~~~

Download VirtualBox and Extension Pack:

 * https://www.virtualbox.org/wiki/Downloads


Vagrant
~~~~~~~

Vagrant is used to mange virtualbox. It needs VirtualBox installed prior to
use.

 * http://vagrantup.com/v1/docs/getting-started/index.html

The following aliases are handy to add to your .bash_profile or .bashrc::

    # vagrant aliases:
    #
    alias v="vagrant"
    alias vst="vagrant status"
    alias vup="vagrant up"
    alias vpr="vagrant provision"
    alias vhl="vagrant halt"
    alias vre="vagrant reload"
    alias vssh="vagrant ssh"

This will save lots of typing.


Ubuntu Base Box
~~~~~~~~~~~~~~~

Currently I'm using an Ubuntu Precise32 basebox from http://www.vagrantbox.es/.
To add this box do the following after vagrant is set up::

    vagrant box add precise32 http://files.vagrantup.com/precise32.box


Common Vagrant Commands
~~~~~~~~~~~~~~~~~~~~~~~

All commands are run from the machine directory i.e. the directory containing
the Vagrantfile.

ssh into dev box::

    vagrant ssh

start a dev box::

    # Start the machine and run the provision.
    #
    # Don't try and set up two machines at the same time. Only do "vagrant up"
    # one machine at a time.
    #
    vagrant up

(re)run provision::

    # If you want to rerun the machine manifest and apply changes when the
    # machine is running:
    vagrant provision

apply changes after Vagrant file has been changed::

    # restart the machine and run provision.
    vagrant reload

stop::

    # Shutdown the machine.
    vagrant halt


Handy Documentation
~~~~~~~~~~~~~~~~~~~

 * http://docs.puppetlabs.com/learning
 * http://bombasticmonkey.com/2011/12/27/stop-writing-puppet-modules-that-suck
 * http://nefariousdesigns.co.uk/vagrant-virtualised-dev-environments.html
 * http://www.12factor.net/dev-prod-parity


Development Boxes
-----------------

Add the following name(s) to your local /etc/hosts set up for machines::

    192.168.43.176    notebook notebook.example.com

Don't try and set up two machines at the same time. Only do "vagrant up" one
machine at a time.


ipynotepad
~~~~~~~~~~

This provisions a box with IPy Notepad running out of the box. This has Pandas,
Matplotlib & Numpy install and useable right away.

After the provision completes open your browser to::

    # http://notebook.example.com:10080
    open http://notebook.example.com:10080

OR::

    # if you don't have /etc/hosts set up:
    open http://192.168.43.176:10080


Required
````````

The notebook folder in your hostmachines home directory::

    mkdir -p ~/notebook

