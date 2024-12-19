# Changelog

This Helm-Chart increase there major version on every breaking change (or major version of Nextcloud itself) inspired by semantic releases.

Here we list all major versions and their breaking changes for migration.

## v7

- update redis to v20 (see [CHANGELOG](https://github.com/bitnami/charts/blob/main/bitnami/redis/CHANGELOG.md#2000-2024-08-09))
- update redis to v21 (see [CHANGELOG](https://github.com/bitnami/charts/blob/main/bitnami/redis/CHANGELOG.md#2100-2025-05-06)
- update postgresql to v16 (see [CHANGELOG](https://github.com/bitnami/charts/blob/main/bitnami/postgresql/CHANGELOG.md#1600-2024-10-02))
    - maybe use [pgautoupgrade](https://github.com/pgautoupgrade/docker-pgautoupgrade) to update to v17 (helm v16), with:
      ```yaml
      postgresql:
        primary:
          initContainers:
            - name: upgrade
              image: "pgautoupgrade/pgautoupgrade:17-alpine"
              env:
                - name: "PGAUTO_ONESHOT"
                  value: "yes"
              volumeMounts:
                - mountPath: "/bitnami/postgresql"
                  name: "data"
      ```
