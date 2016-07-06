# Consul client config
cat > /tmp/consul_client.json <<EOF
{
  "data_dir": "/var/lib/consul",
  "bind_addr": "$1",
  "log_level": "debug",
  "ports": {
    "dns": 53
  },
  "recursors": [
    "8.8.8.8"
  ],
  "dns_config": {
    "allow_stale": true,
    "max_stale": "1s"
  }
}
EOF

sudo mv -f /tmp/consul_client.json /etc/consul.d/consul_client.json
sudo service consul start || sudo service consul restart

# Sleep for 1 second to let service start
sleep 1 && consul join nomad-server1 nomad-server2 nomad-server3

# Default service config
cat > /tmp/nomad.default <<EOF
OPTIONS=""
LOGFILE="/var/log/nomad/nomad.log"
NOMAD_ADDR="http://$1:4646"
EOF

# Client config
cat > /tmp/client.hcl <<EOF
log_level = "DEBUG"
data_dir = "/tmp/client"
bind_addr = "$1"

# Enable the client
client {
    enabled = true
}

consul {
  address = "127.0.0.1:8500"
}
EOF

sudo mv -f /tmp/nomad.default /etc/default/nomad
sudo mv -f /tmp/client.hcl /etc/nomad.d/client.hcl
sudo service nomad start || sudo service nomad restart
