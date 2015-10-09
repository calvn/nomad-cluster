# Input: $1 IP_ADDRESS

# Update apt and get dependencies
sudo apt-get update
sudo apt-get install -y unzip curl wget

# Download Nomad
echo Fetching Nomad...
cd /tmp/
curl -sSL https://dl.bintray.com/mitchellh/nomad/nomad_0.1.2_linux_amd64.zip -o nomad.zip

echo Installing Nomad...
unzip nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/local/bin/nomad

sudo mkdir /etc/nomad.d
sudo chmod a+w /etc/nomad.d

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
