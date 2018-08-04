# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant/util/platform'

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = '2'
Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')

# Load files in the support directory
#Dir.glob('support/**/*.rb').each {|file| load file }

# Vagrant configuration
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define 'purescript-gun', primary: true do |cfg|

    cfg.vm.box = 'ubuntu/trusty64'

    cfg.vm.provision :shell, :path => 'scripts/common.sh', privileged: false
    cfg.vm.provision :shell, :path => 'scripts/javascript.sh', privileged: false
    cfg.vm.provision :shell, :path => 'scripts/purescript.sh', privileged: false

    cfg.vm.provider 'virtualbox' do |v|
      v.name = 'purescript-gun'
      v.memory = 2094
      v.cpus = 2
    end

  end
end
