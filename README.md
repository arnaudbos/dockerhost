# Dockerhost

This repository contains my development VM, which is based on Vagrant and VirtualBox.

> I hate to install stuff on my machine but I love automation, idempotency
> and immutability.

Also I want to play with Vagrant and Docker (Ansible someday soon) but
the state of Docker on Mac and Windows is not satisfying: Boot2Docker,
Docker Toolbox, ... all I read is "install stuff, install stuff, install stuff".

At the moment I'm using both Ubuntu, Mac OS X and Windows 7 on a daily basis
(yes, daily), and I don't want to bother installing stuff.

## Goal

In order to achieve my goal of a reproducible and more or less extensible
development environment, I plan to use this virtual machine as a docker
containers host for projects under development.

> I want to be able to work on multiple projects without
> installing any dependency on my host machine.

- [x] VirtualBox is simple to use and can be installed on all major OSs I use.
- [x] Docker is great for isolating apps/components.
- [x] Vagrant is a great wrapper for VirtualBox and Docker.

> I want each individual app to be loosely coupled
> to this development environment.

- [x] The `app` will know **nothing** about its host.
- [x] The VM will host any app located in its `apps` folder.
- [x] The VM will follow symbolic links placed in its `apps` folder.

**Requirement**: each app must either be running in a Docker container and
provisioning will be done with docker-compose, OR have a `run.sh ` script in
its home directory in order to be started by the `start.sh` provisioning
script (more on that later).

> I want to be able to run any number of projects, which will
> be called `apps` in this context, inside my environment.

- [x] The VM should not be tied to a given list of projects/apps, it
      must be as generic as possible.
- [x] Use a YAML configuration file to specify the Vagrantfile's job.
- [ ] The VM will use docker-compose for provisioning `apps`: "generic" VM only
      goes so far, as I've had issues specifying ports forwarding dynamically
      for apps, so the `config.yml` and `docker-compose.yml` files have to know
      about the apps that need to be configured

> I want to make use of a minimum number of technologies to glue
> the environment together.

- [x] Make use of Docker and bash for scripting for provisioning.
- [x] Play with Ansible someday soon.
- [x] Vagrant and Vagrantfile are ruby, so do not use other scripting languages
      for provisioning: ruby is not my cup of tea but will be OK.
