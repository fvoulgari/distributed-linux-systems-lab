# 🏗 Architecture Overview — Distributed Linux Systems Lab

> A compact multi-node Linux lab for exploring infrastructure behavior as a complete system.

---

## 🧠 Overview

This lab simulates a small distributed Linux infrastructure designed to demonstrate:

- Network segmentation
- Inter-network routing
- NAT and outbound connectivity
- Firewall policy enforcement
- Layer 7 load balancing
- Redundant backend services
- Shared network storage
- Multi-node troubleshooting

The system is intentionally compact while preserving realistic infrastructure behavior.

---

## 🖥 Node Roles

### 🚪 gateway
Central control point of the lab.

Responsibilities:
- Route traffic between networks
- Provide NAT for outbound internet access
- Enforce firewall policies
- Distribute traffic via load balancing
- Host shared storage services

---

### 🧪 client
Traffic origin and validation node.

Responsibilities:
- Generate service requests
- Perform connectivity testing
- Act as troubleshooting origin host

---

### 🧩 backend-a
Backend service node.

Responsibilities:
- Run backend service
- Mount shared storage
- Produce service health logs

---

### 🧩 backend-b
Backend service node.

Responsibilities:
- Run backend service
- Mount shared storage
- Produce service health logs

---

## 🌐 Network Design

### client-net
- Subnet: `192.168.10.0/24`
- Purpose: Client-side internal network

### backend-net
- Subnet: `192.168.20.0/24`
- Purpose: Backend services network

### External Network
- Provides outbound internet access via gateway NAT

---

## 🔢 IP Address Plan

| Node       | Interface      | IP Address       |
|------------|----------------|------------------|
| gateway    | client-net     | 192.168.10.1     |
| gateway    | backend-net    | 192.168.20.1     |
| client     | client-net     | 192.168.10.10    |
| backend-a  | backend-net    | 192.168.20.10    |
| backend-b  | backend-net    | 192.168.20.11    |

---

## 🎯 Design Intent

The topology emphasizes:

- Clear infrastructure boundaries
- Centralized traffic control
- Redundant service tier
- Compact but realistic system design

This structure enables meaningful networking, availability, and troubleshooting scenarios.