# Consul server config
cat > /tmp/consul_server.json <<EOF
{
  "data_dir": "/var/lib/consul",
  "server": true,
  "bind_addr": "$1",
  "bootstrap_expect": 3,
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

sudo mv -f /tmp/consul_server.json /etc/consul.d/consul_server.json
sudo service consul start || sudo service consul restart

# Sleep for 1 second to let service start
sleep 1 && consul join nomad-server1 nomad-server2 nomad-server3

# Default service config
cat > /tmp/nomad.default <<EOF
OPTIONS=""
LOGFILE="/var/log/nomad/nomad.log"
NOMAD_ADDR="http://$1:4646"
EOF

# Server config
cat > /tmp/server.hcl <<EOF
log_level = "DEBUG"
data_dir = "/tmp/server"
bind_addr = "$1"

server {
    enabled = true
    bootstrap_expect = 3
}

consul {
  address = "127.0.0.1:8500"
}
EOF

sudo mv -f /tmp/nomad.default /etc/default/nomad
sudo mv -f /tmp/server.hcl /etc/nomad.d/server.hcl
sudo service nomad start || sudo service nomad restart
