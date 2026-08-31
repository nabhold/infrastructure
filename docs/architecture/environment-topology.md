# Environment topology

## Environments

<!-- markdownlint-disable MD013 -->

| Environment | Region | Management | Purpose |
| --- | --- | --- | --- |
| Local | Developer host or Codespace | Docker Compose | Contract integration and development |
| Development | `af-south-1` initially | Terraform | Shared integration testing |
| Staging | `af-south-1` | Terraform | Production-like verification |
| Production | `af-south-1` | Terraform | Nabhold production workloads |

<!-- markdownlint-enable MD013 -->

Additional East African placement requires a later residency, latency, cost,
and availability decision. A business market does not automatically create a
cloud region or a new application deployment.

## Network zones

1. **Ingress zone:** APISIX public listeners and managed load balancing.
2. **Application zone:** Baobab control-plane API and workers; no public
   database or broker listeners.
3. **Data zone:** PostgreSQL, RabbitMQ, and Redis on private networks.
4. **Management zone:** CI/CD, break-glass administration, telemetry, backup,
   and infrastructure APIs under separate roles.

Default-deny rules apply between zones. Outbound access is allow-listed by
workload. Digital estates never receive management-zone or control-plane
database credentials.

## Data and control paths

- Human and service management traffic reaches the authenticated control-plane
  API through APISIX.
- `baobab-cp` records desired state in PostgreSQL and emits outbox-backed events
  through RabbitMQ.
- Reconciliation workers use scoped provisioner identities to update approved
  resources.
- Redis contains disposable projections. APISIX does not fall back to
  PostgreSQL on a cache miss.
- OpenTelemetry Collector receives traces, metrics, and logs without becoming
  part of the request authorisation path.

## Secrets and state

Terraform state must use encrypted remote storage with locking and restricted
roles. Production secrets are injected from an approved secret manager and are
never committed, embedded in images, or transported in shared contracts.

Backup, recovery objectives, multi-AZ design, and disaster recovery are later
environment decisions and must be accepted before production activation.
