Handy Vagrant + Saltstack Development Environments
==================================================

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
Saltsack and Vagrant. It maybe even inspire them to improve my Saltsack knowledge.

Vagrant is great for managing virtual machine images. I use it with
Saltsack which provisions dependancies and project specifics. Saltsack states and
formulae provide the technical "how to" needed to create and re-create a
specific set up. More generally, this approach can allow a team of developers to
share a common environment. Which can save countless man hours of set up. The
automated set up allows you to concentrate on development and not the annoying
business of environment set up.


Quick Start (ipynotepad)
------------------------

I have vagrant version 1.6.3 and virtualbox version 4.3.12r93733. I'm also
running on Mac OSX 10.9

* Edit the $HOME/devops.ini and add the ipynotepad settings::

    [ipynotepad]
    address=192.168.67.39
    box_url=https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
    box_img=trusty-server-cloudimg-amd64-vagrant-disk1.box

* Change into "ipynotepad" directory.

* Call "./box up" to start the machine.

* Call "./box provision" to set up all parts.

* On your host machine open http://www.ipynotepad/ and off you go.


ipynotepad
----------

.. image:: hist.png
    :width: 50%
    :align: center

A machine to do mathematical work on. It provides IPy Notepad running
numpy, scipy, sympy, matplotlib, pandas and other tools.

Now from the ipynotepad directory start the machine::

    # first time create the machine:
    ./box up

    # The machine will ask for admin access as it wants to set up
    # the 'www.ipynotepad' hostname entry in your /etc/hosts

    # set the machine up:
    ./box provision


This will take a few minutes as it download and provisions the machine. When
the command complete you can open your web browser and go to:

    http://www.ipynotepad/

Now, click on the "New notebook" button. In the main right hand side type the
following into a "cell" and press shift-enter to execute::

    x = hist(randn(1000), 100)

This should produce something like:

.. image:: hist.png
    :width: 50%
    :align: center

Have a look a matplotlib gallery. You can paste any of the demo's source code
into a cell and execute it.

 * http://matplotlib.org/gallery.html

If the machine is destroyed / recreated the notebooks will still be preserved
on the host computer.

Notebooks are save to your home directory on the host machine by default.


devops.ini
~~~~~~~~~~

To run the ipynotepad machine the follow devops.ini entry should be present::

    [ipynotepad]
    address=192.168.67.39
    box_url=https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
    box_img=trusty-server-cloudimg-amd64-vagrant-disk1.box



dockerbox
---------

This is a container for running dockers mainly on MacOSX. Linux can run docker
natively so this isn't needed there.

This sets up the /etc/hosts entries for www.dockerbox pointing it at the current
IP.


devops.ini
~~~~~~~~~~

To run the ipynotepad machine the follow devops.ini entry should be present::

    [dockerbox]
    address=192.168.67.42
    box_url=https://cloud-images.ubuntu.com/vagrant/trusty/trusty-server-cloudimg-amd64-juju-vagrant-disk1.box
    box_img=trusty-server-cloudimg-amd64-juju-vagrant-disk1.box


Needed
------

You need virtualbox and vagrant installed on your host machine.

VirtualBox
~~~~~~~~~~

Download VirtualBox and Extension Pack:

 * https://www.virtualbox.org/wiki/Downloads
 * VirtualBox 4.3.10 and extensions: https://www.virtualbox.org/wiki/Downloads


Vagrant
~~~~~~~

Vagrant is used to mange virtualbox instances. It needs VirtualBox installed
prior to use. In the machine set ups I use a wrapper script called "box". This
is in each directory containing the "Vagrantfile". This wraps the vagrant
command and allows me to have set up in the "devops.ini" file. The vagrant
commands all work with the "box" script e.g. ./box up, ./box reload, ./box ssh

 * Vagrant 1.6.0: http://www.vagrantup.com/downloads.html


Common Commands
```````````````

All commands are run from the machine directory i.e. the directory containing
the Vagrantfile.

ssh into a box::

    ./box ssh

start a dev box::

    # Start the machine and run the provision.
    #
    # Don't try and set up two machines at the same time. Only do "./box up"
    # one machine at a time.
    #
    ./box up

(re)run provision::

    # If you want to rerun the machine manifest and apply changes when the
    # machine is running:
    ./box provision

apply changes after Vagrant file has been changed::

    # restart the machine and run provision.
    ./box reload

stop::

    # Shutdown the machine.
    ./box halt

hostmanager::

    # (re)set up the hostname entries in /etc/hosts based on the current IP
    # set up in "devops.ini". This is performed automatically, however its
    # useful to know this command.
    ./box hostmanager

