Vagrant.configure("2") do |config|
  config.vm.define "docker" do |docker|
    config.vm.box = "centos/7"
  end
  config.vm.network 'private_network', type:'dhcp'
  config.vm.network :forwarded_port, guest: 80, host: 8000,
    auto_correct:true
  config.vm.usable_port_range = 8000..8999
  config.vm.provision "shell", inline: $script
  config.vm.network :forwarded_port, guest: 8080, host: 8080,
    auto_correct: true
  config.vm.synced_folder "./upload/", "/var/lib/docker/volumes/jenkins-data/_data"
end

$script = <<-'SCRIPT'

# disable selinux
cat > /etc/selinux/config <<EOS
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#       enforcing - SELinux security policy is enforced.
#       permissive - SELinux prints warnings instead of enforcing.
#       disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of these two values:
#       targeted - Targeted processes are protected,
#       mls - Multi Level Security protection.
SELINUXTYPE=targeted
EOS

cat > /home/vagrant/docker_install_jenkins.sh <<EOJ
echo "creating network for docker"
sudo docker network create jenkins
echo "creating volumes for docker"
sudo docker volume create jenkins-docker-certs
sudo docker volume create jenkins-data
echo "installing jenkins container from hub"
sudo docker stop isd-jenkins
sudo docker container run --name jenkins --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  --publish 8080:8080 --publish 50000:50000 jenkinsci/blueocean
EOJ

chmod 755 /home/vagrant/docker_install_jenkins.sh
echo 'Please run source ~/docker_install_jenkins.sh , when you need fresh installation of jenkins!!'
echo ' you may only need to run it once , later on no need until to break it bad.'

echo "Installing docker"
yum install docker -y
if [[ $? -eq 0 ]]
 then 
   echo "enabling & starting docker service"
   sudo systemctl enable docker
   sudo systemctl start docker 
else
   echo "Looks like docker is aready installed, exiting"
fi
SCRIPT
