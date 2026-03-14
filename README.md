# Distributed Linux Systems Lab

A hands-on environment for exploring how Linux infrastructure behaves
**as a complete system** --- not just individual servers, but how
multiple machines interact through networking, routing, storage, and
traffic management.

This project builds a small distributed infrastructure locally so you
can observe how real components behave together: routing traffic between
networks, applying firewall rules, sharing storage, and balancing
requests across services.

------------------------------------------------------------------------

## Overview

Most Linux labs focus on individual tools in isolation.\
This lab focuses on **system interaction**.

It provides a reproducible environment where you can explore:

-   Network segmentation
-   Inter-subnet routing
-   NAT and packet forwarding
-   Stateful firewalling
-   Load balancing
-   Shared storage (NFS)
-   Cross-node behavior and failure scenarios

Everything runs locally using virtualization and Vagrant, making it easy
to reset, reproduce, and experiment safely.

------------------------------------------------------------------------

## Lab Architecture

### Nodes

  -----------------------------------------------------------------------
  Node                             Role
  -------------------------------- --------------------------------------
  `gateway`                        Routes traffic between subnets,
                                   provides NAT, firewalling, load
                                   balancing, and NFS storage

  `client`                         Traffic generator and troubleshooting
                                   origin

  `backend-a`                      Backend application node mounting
                                   shared NFS storage

  `backend-b`                      Backend application node mounting
                                   shared NFS storage
  -----------------------------------------------------------------------

------------------------------------------------------------------------

### Network Layout

                            ┌─────────────────────────────┐
                            │           gateway            │
                            │                              │
                            │ eth0: NAT (provider)         │
                            │ eth1: 192.168.10.1           │
                            │ eth2: 192.168.20.1           │
                            └──────────┬──────────┬────────┘
                                       │          │
                  ┌────────────────────┘          └────────────────────┐
                  │                                                     │

           ┌──────────────┐                          ┌──────────────┐
           │    client    │                          │   backend-a  │
           │192.168.10.10 │                          │192.168.20.10 │
           └──────────────┘                          └──────────────┘

                                                    ┌──────────────┐
                                                    │   backend-b  │
                                                    │192.168.20.11 │
                                                    └──────────────┘

            client subnet:   192.168.10.0/24
            backend subnet:  192.168.20.0/24

The **gateway node acts as the control point** between networks and is
responsible for forwarding traffic between the client and backend
layers.

------------------------------------------------------------------------

## Prerequisites

Install the following tools before running the lab:

-   [Vagrant](https://developer.hashicorp.com/vagrant/install)
-   [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)

A virtualization provider:

  Platform              Provider
  --------------------- ---------------------------------------
  Intel macOS / Linux   VirtualBox
  Apple Silicon macOS   VMware Fusion (free personal license)

Provider setup instructions are available in:

    infra/vagrant/README.md

------------------------------------------------------------------------

## Quick Start

Clone the repository and start the environment.

``` bash
git clone <repo-url>
cd distributed-linux-systems-lab
```

Start the lab:

### VirtualBox

``` bash
cd infra/vagrant
vagrant up
```

### VMware Fusion (Apple Silicon)

``` bash
cd infra/vagrant
VAGRANT_DEFAULT_PROVIDER=vmware_desktop vagrant up
```

Verify all machines:

``` bash
vagrant status
```

Connect to a node:

``` bash
vagrant ssh gateway
vagrant ssh client
vagrant ssh backend-a
vagrant ssh backend-b
```

Destroy the environment:

``` bash
vagrant destroy -f
```

------------------------------------------------------------------------

## Learning Objectives

This lab allows you to explore questions such as:

-   How packets move across routed subnets
-   How NAT modifies outbound connections
-   How firewall rules impact forwarded traffic
-   How load balancers distribute requests across backend services
-   How shared NFS storage behaves across multiple machines
-   How failures propagate through distributed infrastructure

------------------------------------------------------------------------

## Project Structure

    distributed-linux-systems-lab
    │
    ├── infra/
    │   └── vagrant/
    │       ├── Vagrantfile      # Multi-VM lab definition
    │       └── README.md        # Provider setup and usage
    │
    ├── ansible/
    │   ├── gateway.yml          # Routing, NAT, firewall, load balancer, NFS
    │   ├── client.yml           # Client configuration and tools
    │   └── webnode.yml          # Backend application node setup

Additional documentation and experiments may be added as the lab
evolves.

------------------------------------------------------------------------

## Purpose

This project is a **personal systems engineering lab** built to develop
practical intuition about how distributed Linux infrastructure behaves
in real environments.

Rather than focusing on individual commands, the goal is to understand
how **networking, services, and systems interact as a whole**.
