# Input: $1 IP_ADDRESS

# Service config
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
EOF

sudo mv -f /tmp/server.hcl /etc/nomad.d/server.hcl
sudo service nomad start || sudo service nomad restart
