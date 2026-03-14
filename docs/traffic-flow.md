# 🔀 Traffic Flow Model — Distributed Linux Systems Lab

This document defines the intended traffic paths in the lab.

These flows represent normal system behavior and serve as the foundation for experiments and troubleshooting scenarios.

---

## 🌐 Flow 1 — Client → Service Access

### Purpose
Primary user traffic path.

### Path
client → gateway → load balancer → backend-a / backend-b → gateway → client

### Description
1. Client sends HTTP request.
2. Gateway receives the request.
3. Load balancer selects a healthy backend.
4. Backend processes request and responds.
5. Response returns through gateway to client.

### What This Demonstrates
- Controlled entry point architecture
- Service abstraction via load balancing
- Multi-node traffic routing
- Symmetric request/response paths

---

## 🌍 Flow 2 — Backend → Internet Access

### Purpose
Allow backend nodes to reach external networks.

### Path
backend → gateway → NAT → internet → gateway → backend

### Description
1. Backend initiates outbound connection.
2. Gateway performs source NAT.
3. External service replies to gateway.
4. Gateway forwards response to backend.

### What This Demonstrates
- NAT mechanics
- Private vs public addressing
- Outbound dependency paths

---

## 🔄 Flow 3 — Client → Gateway (Local Services)

### Purpose
Access services hosted directly on the gateway.

### Path
client → gateway

### Examples
- Load balancer entry point
- Infrastructure services

### What This Demonstrates
- Difference between local vs forwarded traffic
- Service placement impact

---

## 📦 Flow 4 — Backend ↔ Shared Storage

### Purpose
Cross-node coordination via shared state.

### Path
backend-a / backend-b ↔ gateway (shared storage host)

### Description
- Backends read shared scripts
- Backends write shared logs
- Storage acts as coordination layer

### What This Demonstrates
- Service dependency chains
- Shared state patterns
- Storage as an infrastructure layer

---

## 🚫 Non-Intended Paths

These paths are not part of normal operation:

- client → backend directly
- backend-a ↔ backend-b direct service calls

These may be technically possible but are not primary service flows.

---

## 🎯 Design Intent

Traffic should:

- Enter through controlled points
- Cross defined network boundaries
- Follow predictable routing paths

This enables clear troubleshooting and realistic system modeling.