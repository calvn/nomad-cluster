# Client config
cat > /tmp/client.hcl <<EOF
log_level = "DEBUG"
data_dir = "/tmp/client"

# Enable the client
client {
    enabled = true
    servers = ["nomad-server1.node.dc1.consul:4647", "nomad-server2.node.dc1.consul:4647", "nomad-server3.node.dc1.consul:4647"]
}
EOF

sudo mv -f /tmp/client.hcl /etc/nomad.d/client.hcl
sudo service consul start || sudo service consul restart
sudo service nomad start || sudo service nomad restart

# Add localhost nameserver
cat > /tmp/head <<EOF
nameserver 127.0.0.1
EOF

sudo mv -f /tmp/base /etc/resolvconf/resolv.conf.d/base
sudo resolvconf -u

# Consul server config
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

consul join nomad-server1 nomad-server2 nomad-server3
