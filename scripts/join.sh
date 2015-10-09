#!/bin/bash
IP_ADDRESS=$(ifconfig eth1 | grep "inet addr" | cut --delimiter=":" -f 2 | cut --delimiter=" " -f 1)

nomad server-join -address=http://$IP_ADDRESS:4646 nomad-server1.node.dc1.consul nomad-server2.node.dc1.consul nomad-server3.node.dc1.consul
