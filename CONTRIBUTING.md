# Welcome

Thanks for considering a contribution to this Nextcloud repository run by the community! Please make sure you review the [Code of Conduct](./CODE_OF_CONDUCT.md) before proceeding, and keep in mind that this repository is run by volunteers.

# Pull Requests

Before submitting a feature or fix PR, please make sure your changes are targetted to one feature or fix, and all your commits are signed off. (Learn more the DCO [here](https://probot.github.io/apps/dco))

If you're making a change to the chart templates or `values.yaml`, please also do the following:

1. Ensure the chart is linted using [`helm lint`](https://helm.sh/docs/helm/helm_lint/)
2. Test rendering the helm templates from the chart root dir (`charts/nextcloud`) using `helm template .`
    - If you're making a change to a non-default value, please also test that value change locally. You can pass in a custom values file to `helm template` with `--values mycustomvalues.yaml`
3. Test installing the chart. A great tool for this is [`ct`](https://github.com/helm/chart-testing/tree/main) using [`ct install`](https://github.com/helm/chart-testing/blob/main/doc/ct_install.md) on a test cluster like [kind](https://kind.sigs.k8s.io/)
4. Make sure new or changed values are updated in the [values.yaml](./charts/nextcloud/values.yaml) and the [README.md](./charts/nextcloud/README.md)
5. Bump the `version` in the [Chart.yaml](./charts/nextcloud/Chart.yaml) according to [Semantic Versioning](https://semver.org) which uses the format `major.minor.patch`.

Then, please make sure you follow the [pull request template](.github/pull_request_template.md), so we can more quickly review. In order to move your PR forward faster (for instance, bumping the helm chart version for you), please also check the "Allow edits and access to secrets by maintainers" box next to the "Create pull request" button:

![screenshot of the allow edits by maintainers check box to the left of the Create pull request button on GitHub](https://github.com/nextcloud/helm/assets/2389292/3a8044a9-583d-496a-b3d2-4dd699c56ed4)


# Issues

Please make sure you follow one of the [issue templates](.github/ISSUE_TEMPLATE) so we can better help troubleshoot with you.
