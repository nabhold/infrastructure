# Infrastructure trust boundaries

The canonical platform policy is maintained in
`nabhold/shared/docs/security/control-plane-trust-boundaries.md`.

This repository enforces it through separate deployment roles, private data
services, encrypted state, workload identities, immutable audit trails, and
least-privilege provisioner accounts. No deployment workflow may expose cloud,
database, broker, Redis, or APISIX administrative credentials to a pull request
from untrusted code.

Production deployment requires an explicitly protected GitHub environment and
review. Pull-request workflows may plan and validate infrastructure, but may not
apply it.
