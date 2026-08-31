# Nabhold Infrastructure

`nabhold/infrastructure` is the environment provisioner for the Nabhold
platform. It owns declarative infrastructure and deployment automation; it does
not own tenant-management business logic or canonical cross-repository
contracts.

## Foundation 0 status

The initial architecture and trust boundaries are accepted. No runtime
infrastructure is introduced in Foundation 0. The next foundation will add a
local Docker Compose topology after the contracts in `nabhold/shared` are
reviewed.

## Ownership

This repository will contain:

- Docker Compose for local platform dependencies;
- Terraform modules and environment compositions for AWS;
- APISIX platform configuration and bootstrap policy;
- RabbitMQ, PostgreSQL, and Redis deployment configuration;
- Kubernetes/Helm definitions when their adoption is approved;
- observability and backup configuration;
- environment deployment workflows and runbooks.

It must not contain:

- Baobab control-plane API or worker code;
- digital-estate application code;
- canonical API, event, or domain schemas;
- plaintext secrets or tenant credentials;
- deployment logic copied into application repositories.

## Contract dependencies

Environment declarations conform to
`nabhold/shared/contracts/infrastructure/v1/environment-topology.schema.json`.
The control-plane runtime in `nabhold/baobab-cp` interacts with provisioned
services through narrowly scoped APIs and workload identities.

## Planned layout

```text
compose/                 Local development topology
terraform/
  modules/               Reusable infrastructure modules
  environments/          Reviewed environment compositions
apisix/                  Gateway bootstrap and platform policy
observability/           OpenTelemetry and metrics configuration
deploy/                  Deployment workflows and scripts
docs/adr/                Infrastructure decisions
docs/architecture/       Environment topology
docs/runbooks/           Operational procedures
```

## Initial platform services

<!-- markdownlint-disable MD013 -->

| Service | Purpose | Source of truth |
| --- | --- | --- |
| Apache APISIX | Ingress, routing, and gateway policy | APISIX configuration reconciled by `baobab-cp` |
| PostgreSQL 17 | Control-plane metadata and approved tenant database boundaries | PostgreSQL desired state in `baobab-cp` |
| RabbitMQ | Commands and lifecycle events with DLQs | Versioned AsyncAPI contracts in `shared` |
| Redis 7 | Rebuildable route and status projections | PostgreSQL remains authoritative |
| OpenTelemetry Collector | Vendor-neutral telemetry pipeline | Environment configuration in this repository |

<!-- markdownlint-enable MD013 -->

Production is targeted at AWS Cape Town (`af-south-1`) through Terraform.
Kubernetes, Helm, and Temporal are deliberately deferred until operational need
justifies their additional machinery.
