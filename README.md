# Nextcloud Helm Charts

[Helm](https://helm.sh) repo for different charts related to Nextcloud which can be installed on [Kubernetes](https://kubernetes.io)

## Add Helm repository

To install the repo just run:

```console
helm repo add nextcloud https://spirkaa.github.io/helm-nextcloud
helm repo update
```

## Helm Charts

* [nextcloud](https://spirkaa.github.io/helm-nextcloud)

  ```console
  helm install my-release nextcloud/nextcloud
  ```
