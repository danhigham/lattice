Vagrant.configure("2") do |config|

  ## credit: https://stefanwrobel.com/how-to-make-vagrant-performance-not-suck
  config.vm.provider "virtualbox" do |v|
    host = RbConfig::CONFIG['host_os']
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else
      cpus = 2
      mem = 2048
    end

    v.customize ["modifyvm", :id, "--memory", mem]
    v.customize ["modifyvm", :id, "--cpus", cpus]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]

    override.ssh.private_key_path = ENV["AWS_SSH_PRIVATE_KEY_PATH"]
  end

  provider_is_aws = (!ARGV.nil? && ARGV.join('').match(/provider(=|\s+)aws/))

  if provider_is_aws
    system_values = <<-SCRIPT
      SYSTEM_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
      SYSTEM_DOMAIN=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
    SCRIPT

    config.ssh.insert_key = false
  else
    system_ip = ENV["LATTICE_SYSTEM_IP"] || "192.168.11.11"
    system_domain = ENV["LATTICE_SYSTEM_DOMAIN"] || "#{system_ip}.xip.io"

    system_values = <<-SCRIPT
      echo "SYSTEM_IP=#{system_ip}" >> /var/lattice/setup/lattice-environment
      echo "SYSTEM_DOMAIN=#{system_domain}" >> /var/lattice/setup/lattice-environment
    SCRIPT

    config.vm.network "private_network", ip: system_ip
  end

  config.vm.box = "lattice/ubuntu-trusty-64"
  config.vm.box_version = '0.2.6'

  config.vm.provision "shell" do |s|
    s.inline = <<-SCRIPT
      mkdir -pv /var/lattice/setup
      #{system_values}
      echo "CONSUL_SERVER_IP=$SYSTEM_IP" >> /var/lattice/setup/lattice-environment
      echo "SYSTEM_IP=$SYSTEM_IP" >> /var/lattice/setup/lattice-environment
      echo "GARDEN_EXTERNAL_IP=$SYSTEM_IP" >> /var/lattice/setup/lattice-environment
      echo "SYSTEM_DOMAIN=$SYSTEM_DOMAIN" >> /var/lattice/setup/lattice-environment
      echo "LATTICE_CELL_ID=cell-01" >> /var/lattice/setup/lattice-environment
      echo "CONDENSER_ON=#{ENV['CONDENSER_ON'].to_s}" >> /var/lattice/setup/lattice-environment
      echo "DOWNLOAD_ROOTFS=#{ENV['DOWNLOAD_ROOTFS'].to_s}" >> /var/lattice/setup/lattice-environment

      cp /var/lattice/setup/lattice-environment /vagrant/.lattice-environment
    SCRIPT
  end

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.vm.provision "shell" do |s|
      s.inline = "grep -i proxy /etc/environment >> /var/lattice/setup/lattice-environment || true"
    end
  end

  lattice_tar_version=File.read(File.join(File.dirname(__FILE__), "Version")).chomp
  if lattice_tar_version =~ /\-[[:digit:]]+\-g[0-9a-fA-F]{7,10}$/
    lattice_tar_url="https://s3-us-west-2.amazonaws.com/lattice/unstable/#{lattice_tar_version}/lattice.tgz"
  else
    lattice_tar_url="https://s3-us-west-2.amazonaws.com/lattice/releases/#{lattice_tar_version}/lattice.tgz"
  end

  config.vm.provision "shell" do |s|
    s.path = "cluster/scripts/install-from-tar"
    s.args = ["collocated", ENV["VAGRANT_LATTICE_TAR_PATH"].to_s, lattice_tar_url]
  end

  config.vm.provision "shell" do |s|
    s.inline = "export $(cat /var/lattice/setup/lattice-environment) && printf '\nLattice is now installed and running.\nYou may target it using: ltc target %s\n \n' $SYSTEM_DOMAIN"
  end
end
