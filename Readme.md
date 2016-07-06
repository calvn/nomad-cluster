# Nomad Cluster
This project provides a way to quickly spin up a test nomad cluster with three servers and one client, each agent on its own VM.

```ShellSession
$ vagrant status
Current machine states:

nomad-server1             not created (virtualbox)
nomad-server2             not created (virtualbox)
nomad-server3             not created (virtualbox)
nomad-client              not created (virtualbox)
```

## Commands
```ShellSession
$ vagrant up
```

From the guest:
```ShellSession
vagrant@nomad-server1:~$ IP_ADDRESS=$(ifconfig eth1 | grep "inet addr" | cut --delimiter=":" -f 2 | cut --delimiter=" " -f 1)

vagrant@nomad-server1:~$ nomad server-members -address=http://$IP_ADDRESS:4646
Name                  Address        Port  Status  Leader  Protocol  Build  Datacenter  Region
nomad-server1.global  192.168.111.2  4648  alive   false   2         0.4.0  dc1         global
nomad-server2.global  192.168.111.3  4648  alive   true    2         0.4.0  dc1         global
nomad-server3.global  192.168.111.4  4648  alive   false   2         0.4.0  dc1         global

vagrant@nomad-server1:~$ nomad node-status -address=http://$IP_ADDRESS:4646
ID        DC   Name          Class   Drain  Status
5aac3d37  dc1  nomad-client  <none>  false  ready
```

From your host:
```
$ curl nomad-server1:4646/v1/nodes
[
    {
        "ID": "5aac3d37-6f36-db55-c473-7afdead2d285",
        "Datacenter": "dc1",
        "Name": "nomad-client",
        "NodeClass": "",
        "Drain": false,
        "Status": "ready",
        "StatusDescription": "",
        "CreateIndex": 9,
        "ModifyIndex": 12
    }
]

$ curl url nomad-server1:4646/v1/agent/members?pretty
[
    {
        "Addr": "192.168.111.4",
        "DelegateCur": 4,
        "DelegateMax": 4,
        "DelegateMin": 2,
        "Name": "nomad-server3.global",
        "Port": 4648,
        "ProtocolCur": 2,
        "ProtocolMax": 4,
        "ProtocolMin": 1,
        "Status": "alive",
        "Tags": {
            "dc": "dc1",
            "vsn": "1",
            "mvn": "1",
            "build": "0.4.0",
            "port": "4647",
            "expect": "3",
            "role": "nomad",
            "region": "global"
        }
    },
    {
        "Addr": "192.168.111.3",
        "DelegateCur": 4,
        "DelegateMax": 4,
        "DelegateMin": 2,
        "Name": "nomad-server2.global",
        "Port": 4648,
        "ProtocolCur": 2,
        "ProtocolMax": 4,
        "ProtocolMin": 1,
        "Status": "alive",
        "Tags": {
            "region": "global",
            "dc": "dc1",
            "vsn": "1",
            "mvn": "1",
            "build": "0.4.0",
            "port": "4647",
            "expect": "3",
            "role": "nomad"
        }
    },
    {
        "Addr": "192.168.111.2",
        "DelegateCur": 4,
        "DelegateMax": 4,
        "DelegateMin": 2,
        "Name": "nomad-server1.global",
        "Port": 4648,
        "ProtocolCur": 2,
        "ProtocolMax": 4,
        "ProtocolMin": 1,
        "Status": "alive",
        "Tags": {
            "build": "0.4.0",
            "port": "4647",
            "expect": "3",
            "role": "nomad",
            "region": "global",
            "dc": "dc1",
            "vsn": "1",
            "mvn": "1"
        }
    }
]
```

## Caveats
This project is very opinionated on some on some of the setup, such as data and config directories and private network IPs.
Feel free to change those to suit your particular needs.

In addition to Nomad, it installs Consul agent on each of the instances to be used for service registration and discovery.

## Prerequisites:
- Vagrant 1.7.4+
