---
name: "General Issue"
about: "Create an issue to report something not working."
title: "A descriptive title of the issue"
labels: ''
assignees: ''

---

## Describe your Issue
<!-- A clear and concise description of what the issue or bug is -->

### Logs and Errors
<!-- Give us any errors you're getting -->
<!-- Let us know where you got the log, e.g. nextcloud container or nginx container -->
<!-- You can get the pod logs with: `kubectl logs` (remove any sensitive data ahead of time) -->

## Describe your Environment

- Kubernetes distribution: <!-- examples: k3s, k0s, eks, gke -->

- Helm Version (or App that manages helm): <!-- example: Using helm version 3.11, or include data about what is running helm, e.g. ArgoCD version 2.5.8 -->

- Helm Chart Version: <!-- example: 3.4.3 -->

- `values.yaml`:

```yaml
# paste your values.yaml (anonymize any sensitive data)
```

## Additional context, if any
<!-- Also note any additional relevant info about your environment. -->
<!-- example: If your issue is related to persistent volumes, let us know you're using NFS or EFS, for instance. -->
