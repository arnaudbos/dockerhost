# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

# Specify Vagrant version and Vagrant API version
VAGRANTFILE_API_VERSION = "2"

CURRENT_DIR    = File.dirname(File.expand_path(__FILE__))
CONFIGS        = YAML.load_file("#{CURRENT_DIR}/config.yml")
VAGRANT_CONFIG = CONFIGS['configs'][CONFIGS['configs']['env']]
DOCKERHOST_CONFIG = VAGRANT_CONFIG['dockerhost']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.provider :virtualbox do |vb|
      vb.name = "#{DOCKERHOST_CONFIG['name']}"
  end

  config.vm.define "#{DOCKERHOST_CONFIG['name']}"
  config.vm.box = "#{DOCKERHOST_CONFIG['box']}"

  # Prosision
  ##############################################################################
  # Loop over provisioning scripts
  DOCKERHOST_CONFIG['scripts'].each do |script|
    config.vm.provision "shell", path: script
  end

  config.vm.provision "docker"

  # Ports
  ##############################################################################
  DOCKERHOST_CONFIG['forward_ports'].each do |forward_port|
    config.vm.network 'forwarded_port',
      host: forward_port['host'], guest: forward_port['guest']
  end

  # folders
  ##############################################################################
  config.vm.synced_folder ".", "/vagrant", disabled: true

  DOCKERHOST_CONFIG['shared_folders'].each do |shared_folder|
    config.vm.synced_folder shared_folder['host'], shared_folder['guest']
  end
end
