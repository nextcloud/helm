# Nextcloud Helm Charts

[Helm](https://helm.sh) repo for different charts related to Nextcloud which can be installed on [Kubernetes](https://kubernetes.io)

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

For more information, please checkout the chart level [README.md](./charts/nextcloud/README.md).

### Support and Contribution
This helm chart is community maintained, and not supported by Nextcloud GmbH. Please also review the official [NextCloud Code of Conduct](https://nextcloud.com/contribute/code-of-conduct/) before contributing.

#### Questions and Discussions
[GitHub Discussion](https://github.com/nextcloud/helm/discussions)

#### Bugs and other Issues
If you have a bug to report or a feature to request, you can first search the [GitHub Issues](https://github.com/nextcloud/helm/issues), and  if you can't find what you're looking for, feel free to open an issue.

#### Contributing to the Code
We're always happy to review a pull request :) Please just be sure to check the pull request template to make sure you fufill all the required checks, most importantly the [DCO](https://probot.github.io/apps/dco/).
