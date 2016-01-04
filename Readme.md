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

## Caveats
This project is very opinionated on some on some of the setup, such as data and config directories and private network IPs.
Feel free to change those to suit your particular needs.

In addition to Nomad, it installs Consul agent on each of the boxes to be used for service registration and discovery.

## Prerequisites:
- Vagrant 1.7.4+
