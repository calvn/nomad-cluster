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
sudo service nomad start || sudo service nomad restart
