#!/bin/bash
IP_ADDRESS=$(ifconfig eth1 | grep "inet addr" | cut --delimiter=":" -f 2 | cut --delimiter=" " -f 1)

consul join nomad-server1 nomad-server2 nomad-server3

nomad server-join -address=http://$IP_ADDRESS:4646 nomad-server1 nomad-server2 nomad-server3
