# Nextcloud Helm Charts

[Helm](https://helm.sh) repo for different charts related to Nextcloud which can be installed on [Kubernetes](https://kubernetes.io)

⚠️⚠️⚠️ This project is maintained by community volunteers and designed for expert use. For quick and easy deployment that supports the full set of Nextcloud Hub features, use the [Nextcloud All-in-One project](https://github.com/nextcloud/all-in-one#nextcloud-all-in-one) maintained by Nextcloud GmbH.

### Add Helm repository

To install the repo just run:

```bash
helm repo add nextcloud https://nextcloud.github.io/helm/
helm repo update
```

### Helm Charts

* [nextcloud](https://nextcloud.github.io/helm/)

  ```bash
  helm install my-release nextcloud/nextcloud
  ```
