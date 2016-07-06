# Input: $1 IP_ADDRESS

# Update apt and get dependencies
sudo apt-get update
sudo apt-get install -y unzip curl wget

# Download Nomad
echo Fetching Nomad...
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/0.4.0/nomad_0.4.0_linux_amd64.zip -o nomad.zip

echo Installing Nomad...
unzip nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/local/bin/nomad

sudo mkdir -p /etc/nomad.d
sudo mkdir -p /var/lib/nomad
sudo chmod a+w /etc/nomad.d
sudo chmod a+w /var/lib/nomad

# Set up Nomad as a service
cat > /tmp/nomad.conf <<EOF
description "Nomad agent as a service"
author "Calvin Leung Huang"

start on runlevel [2345]
stop on shutdown

script
  if [ -f /etc/default/nomad ]; then
    . /etc/default/nomad
  fi
  CMD="/usr/local/bin/nomad agent -config /etc/nomad.d/ \$OPTIONS"
  exec \$CMD
end script
EOF

sudo mv -f /tmp/nomad.conf /etc/init/nomad.conf


# Download consul
echo Fetching Consul...
cd /tmp/
curl -sSL https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip -o consul.zip

echo Installing Consul...
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul

sudo mkdir -p /etc/consul.d
sudo chmod a+w /etc/consul.d
sudo mkdir -p /var/lib/consul
sudo chmod a+w /var/lib/consul

#Set up Consul as a service
cat > /tmp/consul.conf <<EOF
description "Consul agent as a service"
author "Calvin Leung Huang"

start on runlevel [2345]
stop on shutdown

script
  if [ -f /etc/default/consul ]; then
    . /etc/default/consul
  fi
  CMD="/usr/local/bin/consul agent -config-dir /etc/consul.d/ \$OPTIONS"
  exec \$CMD
end script
EOF

sudo mv -f /tmp/consul.conf /etc/init/consul.conf
