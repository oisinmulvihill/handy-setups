Handy Vagrant + Puppet Development Environment Configuration
============================================================

.. contents::


Introduction
------------

In August 2012 I decided use virtual machines entirely for my development
environments. Previously I would set up a project's dependancies directly
on my Mac laptop. This could prove quite painful as most of the dependancies
compile best on Linux. This choice proved itself in other ways on changing
laptop. I was able to get back to being productive in a very short time. I've
since extended this approach to all machines I work on.

This project sets up (provisions) a blank Ubuntu machines with "technology
stacks" I'm developing with or interested in. I'm slowly going to move in set
ups I'm using which I can make public. This should help others interested in
Puppet and Vagrant. It maybe even inspire them to improve my puppet knowledge.

Vagrant is great for managing virtual machine images. I use it with
Puppet which provisions dependancies and project specifics. Puppet modules and
manifest files provides the technical "how to" needed to create and re-create a
specific set up. More generally, this approach can allow a team of developers to
share a common environment. Which can save countless man hours of set up. The
automated set up allows you to concentrate on development and not the annoying
business of environment set up.


Quick Start
-----------

 * Choose a devbox.
 * Change into the devboxes directory on the command line.
 * Call "vagrant up" to start the machine.


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
    192.168.43.178    meteor meteor.example.com

Don't try and set up two machines at the same time. Only do "vagrant up" one
machine at a time.


meteorjs
~~~~~~~~

This create a machine with MongoDB and Meteor installed ready to start
development on. Internet access is needed for this machine to be provisioned.

From the meteorjs directory start the machine::

    vagrant up


ipynotepad
~~~~~~~~~~

A machine to do mathematical work on. It provides IPy Notepad running
matplotlib, pandas, numpy and other tools.

Create the notebook folder in your home directory (on the host machine)::

    mkdir ~/notebook

Now from the ipynotepad directory start the machine::

    vagrant up

This will take a few minutes as it download and provisions the machine. When
the command complete you can open your web browser and go to:

    http://192.168.43.176:10080/

Or, If you set up the /etc/hosts with local dns set up:

    http://notepad.example.com:10080

Handy OSX Command line::

    open http://192.168.43.176:10080/

Now, click on the "New notebook" button. In the main right hand side type the
following into a "cell" and press shift-enter to execute::

    x = randn(10000)
    hist(x, 100)

Have a look a matplotlib gallery. You can paste any of the demo's source code
into a cell and execute it.

 * http://matplotlib.org/gallery.html

If the machine is destroyed / recreated the notebooks will still be preserved
on the host computer.
