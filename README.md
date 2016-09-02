# Dockerhost

This repository contains my development VM, which is based on Vagrant and VirtualBox.

> I hate to install stuff on my machine but I love automation, idempotency
> and immutability.

Also I want to play with Vagrant and Docker (Ansible someday soon) but
the state of Docker on Mac and Windows is not satisfying: Boot2Docker,
Docker Toolbox, ... all I read is "install stuff, install stuff, install stuff".
At the moment I'm using both Ubuntu, Mac OS X and Windows 7 on a daily basis,
and I don't want to bother.

## Goal

In order to achieve my goal of a reproducible and more or less extensible
development environment, I plan to use this virtual machine as a docker
containers host for projects under development.

> As an obsessive compulsive, I want to be able to work on projects without
> installing any dependency on my host machine.

* VirtualBox is simple to use and can be installed on all major OSs I use.
* Docker is great for isolating apps/components.
* Vagrant is a great wrapper for VirtualBox and Docker.

> As a developer, I want to be able to run any number of projects, which will
be called `apps` in this context, inside my environment.

* The VM must not be tied to a given list of projects/apps, it
must be as generic as possible.
* Use a YAML configuration file to specify the Vagrantfile's job.

> As a developer, I want each individual app to be loosely coupled to this
development environment.

* The VM will host any app located in its `apps` folder.
* The VM will follow symbolic links placed in its `apps` folder.
* **Requirement**: each app must have a `run.sh` script in its home directory
in order to be started by the VM provisioning.
* **Requirement**: each app running in a Docker container ueeds a YAML
configuration file with [the following structure][vagrantfile-config] along
with its Vagrantfile.

> As a maintainer, I want to make use of a minmum number of technologies to glue
the environment together.

* Make use of bash for scripting.
* Play with Ansible someday soon.
* Vagrant and Vagrantfile are ruby, so do not use other languages
for provisioning, ruby will be OK.

[vagrantfile-config]: deadlink
