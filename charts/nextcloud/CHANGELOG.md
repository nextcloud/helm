# Changelog

This Helm-Chart increase there major version on every breaking change (or major version of Nextcloud itself) inspired by semantic releases.

Here we list all major versions and their breaking changes for migration.

## v8
- `cronjob.command` was renamed to `cronjob.sidecar.command` to avoid confusion with the cronjob command. Please update your `values.yaml` accordingly.

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
- update mariadb to v19 (see [CHANGELOG](https://github.com/bitnami/charts/blob/main/bitnami/mariadb/CHANGELOG.md#1900-2024-07-11))
- update mariadb to v20 (see [CHANGELOG](https://github.com/bitnami/charts/blob/main/bitnami/mariadb/CHANGELOG.md#2000-2024-11-08))
- update nextcloud to v31 (see [CHANGELOG](https://nextcloud.com/changelog/#31-0-0))
