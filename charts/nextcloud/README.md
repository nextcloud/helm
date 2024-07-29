# Nextcloud Helm Chart

[Nextcloud](https://nextcloud.com/) is a file sharing server that puts the control and security of your own data back into your hands.

## TL;DR;

```console
helm repo add nextcloud https://nextcloud.github.io/helm/
helm install my-release nextcloud/nextcloud
```

## Quick Links

* [Introduction](#introduction)
* [Prerequisites](#prerequisites)
* [Installing the Chart](#installing-the-chart)
* [Uninstalling the Chart](#uninstalling-the-chart)
* [Configuration](#configuration)
    * [Database Configurations](#database-configurations)
    * [Object Storage as Primary Storage Configuration](#object-storage-as-primary-storage-configuration)
    * [Persistence Configurations](#persistence-configurations)
    * [Metrics Configurations](#metrics-configurations)
    * [Probes Configurations](#probes-configurations)
* [Cron jobs](#cron-jobs)
* [Using the nextcloud docker image auto-configuration via env vars](#using-the-nextcloud-docker-image-auto-configuration-via-env-vars)
* [Multiple config.php file](#multiple-configphp-file)
* [Using nginx](#using-nginx)
    * [Service discovery with nginx and ingress](#service-discovery-with-nginx-and-ingress)
* [Preserving Source IP](#preserving-source-ip)
* [Hugepages](#hugepages)
* [HPA (Clustering)](#hpa-clustering)
* [Adjusting PHP ini values](#adjusting-php-ini-values)
* [Running `occ` commands](#running-occ-commands)
    * [Putting Nextcloud into maintanence mode](#putting-nextcloud-into-maintanence-mode)
    * [Downloading models for recognize](#downloading-models-for-recognize)
* [Backups](#backups)
* [Upgrades](#upgrades)
* [Troubleshooting](#troubleshooting)
    * [Logging](#logging)
        * [Changing the logging behavior](#changing-the-logging-behavior)
        * [Viewing the logs](#viewing-the-logs)
            * [Exec into the kubernetes pod:](#exec-into-the-kubernetes-pod)
            * [Then look for the `nextcloud.log` file with tail or cat:](#then-look-for-the-nextcloudlog-file-with-tail-or-cat)
            * [Copy the log file to your local machine:](#copy-the-log-file-to-your-local-machine)
        * [Sharing the logs](#sharing-the-logs)

## Introduction

This chart bootstraps an [nextcloud](https://hub.docker.com/_/nextcloud/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

You will also need a database compatible with Nextcloud. For more info, please see the [Database Configuration](#database-configurations) section below.

If you want to persist data accross installs and upgrades, you'll need to configure persistence. For more info, please see the [Persistence Configuration](#persistence-configurations) section below.

We also package the following helm charts from Bitnami for you to _optionally_ use:

| Chart                                                                        | Descrption                      |
|------------------------------------------------------------------------------|---------------------------------|
| [Redis](https://github.com/bitnami/charts/tree/main/bitnami/redis)           | For enabling caching            |
| [PostgreSQL](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) | For use as an external database |
| [MariaDB](https://github.com/bitnami/charts/tree/main/bitnami/mariadb)       | For use as an external database |

## Prerequisites

- Kubernetes 1.24+
- Persistent Volume provisioner support in the underlying infrastructure
- Helm >=3.7.0 ([for subchart scope exposing](nextcloud/helm#152))

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add nextcloud https://nextcloud.github.io/helm/
helm install my-release nextcloud/nextcloud
```

The command deploys nextcloud on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the nextcloud chart and their default values.

| Parameter                                                   | Description                                                                                         | Default                    |
|-------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|----------------------------|
| `image.repository`                                          | nextcloud Image name                                                                                | `nextcloud`                |
| `image.flavor`                                              | nextcloud Image type (Options: apache, fpm)                                                         | `apache`                   |
| `image.tag`                                                 | nextcloud Image tag                                                                                 | `appVersion`               |
| `image.pullPolicy`                                          | Image pull policy                                                                                   | `IfNotPresent`             |
| `image.pullSecrets`                                         | Specify image pull secrets                                                                          | `nil`                      |
| `replicaCount`                                              | Number of nextcloud pods to deploy                                                                  | `1`                        |
| `ingress.className`                                         | Name of the ingress class to use                                                                    | `nil`                      |
| `ingress.enabled`                                           | Enable use of ingress controllers                                                                   | `false`                    |
| `ingress.servicePort`                                       | Ingress' backend servicePort                                                                        | `http`                     |
| `ingress.annotations`                                       | An array of service annotations                                                                     | `nil`                      |
| `ingress.labels`                                            | An array of service labels                                                                          | `nil`                      |
| `ingress.path`                                              | The `Path` to use in Ingress' `paths`                                                               | `/`                        |
| `ingress.pathType`                                          | The `PathType` to use in Ingress' `paths`                                                           | `Prefix`                   |
| `ingress.tls`                                               | Ingress TLS configuration                                                                           | `[]`                       |
| `nextcloud.host`                                            | nextcloud host to create application URLs, updates trusted_domains at installation time only        | `nextcloud.kube.home`      |
| `nextcloud.username`                                        | User of the application                                                                             | `admin`                    |
| `nextcloud.password`                                        | Application password                                                                                | `changeme`                 |
| `nextcloud.existingSecret.enabled`                          | Whether to use an existing secret or not                                                            | `false`                    |
| `nextcloud.existingSecret.secretName`                       | Name of the existing secret                                                                         | `nil`                      |
| `nextcloud.existingSecret.usernameKey`                      | Name of the key that contains the username                                                          | `nil`                      |
| `nextcloud.existingSecret.passwordKey`                      | Name of the key that contains the password                                                          | `nil`                      |
| `nextcloud.existingSecret.smtpUsernameKey`                  | Name of the key that contains the SMTP username                                                     | `nil`                      |
| `nextcloud.existingSecret.smtpPasswordKey`                  | Name of the key that contains the SMTP password                                                     | `nil`                      |
| `nextcloud.existingSecret.smtpHostKey`                      | Name of the key that contains the SMTP hostname                                                     | `nil`                      |
| `nextcloud.existingSecret.tokenKey`                         | Name of the key that contains the nextcloud metrics token                                           | `''`                       |
| `nextcloud.update`                                          | Trigger update if custom command is used                                                            | `0`                        |
| `nextcloud.containerPort`                                   | Customize container port when not running as root                                                   | `80`                       |
| `nextcloud.trustedDomains`                                  | Optional space-separated list of trusted domains                                                    | `[]`                       |
| `nextcloud.datadir`                                         | nextcloud data dir location                                                                         | `/var/www/html/data`       |
| `nextcloud.mail.enabled`                                    | Whether to enable/disable email settings                                                            | `false`                    |
| `nextcloud.mail.fromAddress`                                | nextcloud mail send from field                                                                      | `nil`                      |
| `nextcloud.mail.domain`                                     | nextcloud mail domain                                                                               | `nil`                      |
| `nextcloud.mail.smtp.host`                                  | SMTP hostname                                                                                       | `nil`                      |
| `nextcloud.mail.smtp.secure`                                | SMTP connection `ssl` or empty                                                                      | `''`                       |
| `nextcloud.mail.smtp.port`                                  | Optional SMTP port                                                                                  | `nil`                      |
| `nextcloud.mail.smtp.authtype`                              | SMTP authentication method                                                                          | `LOGIN`                    |
| `nextcloud.mail.smtp.name`                                  | SMTP username, ONLY the part before the domain name. i.e. 'postmaster' NOT 'postmaster@example.com' | `''`                       |
| `nextcloud.mail.smtp.password`                              | SMTP password                                                                                       | `''`                       |
| `nextcloud.configs`                                         | Config files created in `/var/www/html/config`                                                      | `{}`                       |
| `nextcloud.persistence.subPath`                             | Set the subPath for nextcloud to use in volume                                                      | `nil`                      |
| `nextcloud.phpConfigs`                                      | PHP Config files created in `/usr/local/etc/php/conf.d`                                             | `{}`                       |
| `nextcloud.defaultConfigs.\.htaccess`                       | Default .htaccess to protect `/var/www/html/config`                                                 | `true`                     |
| `nextcloud.defaultConfigs.apache-pretty-urls\.config\.php`  | Default Apache configuration for rewrite urls                                                       | `true`                     |
| `nextcloud.defaultConfigs.apcu\.config\.php`                | Default configuration to define APCu as local cache                                                 | `true`                     |
| `nextcloud.defaultConfigs.apps\.config\.php`                | Default configuration for apps                                                                      | `true`                     |
| `nextcloud.defaultConfigs.autoconfig\.php`                  | Default auto-configuration for databases                                                            | `true`                     |
| `nextcloud.defaultConfigs.redis\.config\.php`               | Default Redis configuration                                                                         | `true`                     |
| `nextcloud.defaultConfigs.reverse-proxy\.config\.php`       | Default Reverse proxy configuration                                                                 | `true`                     |
| `nextcloud.defaultConfigs.s3\.config\.php`                  | Default configuration for S3 as primary Object Storage                                              | `true`                     |
| `nextcloud.defaultConfigs.smtp\.config\.php`                | Default configuration for smtp                                                                      | `true`                     |
| `nextcloud.defaultConfigs.swift\.config\.php`               | Default configuration for Swift as primary Object Storage                                           | `true`                     |
| `nextcloud.defaultConfigs.upgrade-disable-web\.config\.php` | Default config to disable the web-based updater as the default docker image does not suppor it      | `true`                     |
| `nextcloud.strategy`                                        | specifies the strategy used to replace old Pods by new ones                                         | `type: Recreate`           |
| `nextcloud.extraEnv`                                        | specify additional environment variables                                                            | `{}`                       |
| `nextcloud.extraSidecarContainers`                          | specify additional sidecar containers                                                               | `[]`                       |
| `nextcloud.extraInitContainers`                             | specify additional init containers                                                                  | `[]`                       |
| `nextcloud.extraVolumes`                                    | specify additional volumes for the NextCloud pod                                                    | `{}`                       |
| `nextcloud.extraVolumeMounts`                               | specify additional volume mounts for the NextCloud pod                                              | `{}`                       |
| `nextcloud.securityContext`                                 | Optional security context for the NextCloud container                                               | `nil`                      |
| `nextcloud.podSecurityContext`                              | Optional security context for the NextCloud pod (applies to all containers in the pod)              | `nil`                      |
| `nginx.enabled`                                             | Enable nginx (requires you use php-fpm image)                                                       | `false`                    |
| `nginx.image.repository`                                    | nginx Image name, e.g. use `nginxinc/nginx-unprivileged` for rootless container                     | `nginx`                    |
| `nginx.image.tag`                                           | nginx Image tag                                                                                     | `alpine`                   |
| `nginx.image.pullPolicy`                                    | nginx Image pull policy                                                                             | `IfNotPresent`             |
| `nginx.image.pullPolicy`                                    | nginx Image pull policy                                                                             | `IfNotPresent`             |
| `nginx.containerPort`                                       | Customize container port e.g. when not running as root                                              | `IfNotPresent`             |
| `nginx.config.default`                                      | Whether to use nextcloud's recommended nginx config                                                 | `true`                     |
| `nginx.config.custom`                                       | Specify a custom config for nginx                                                                   | `{}`                       |
| `nginx.resources`                                           | nginx resources                                                                                     | `{}`                       |
| `nginx.securityContext`                                     | Optional security context for the nginx container                                                   | `nil`                      |
| `nginx.extraEnv`                                            | Optional environment variables for the nginx container                                              | `nil`                      |
| `lifecycle.postStartCommand`                                | Specify deployment lifecycle hook postStartCommand                                                  | `nil`                      |
| `lifecycle.preStopCommand`                                  | Specify deployment lifecycle hook preStopCommand                                                    | `nil`                      |
| `redis.enabled`                                             | Whether to install/use redis for locking                                                            | `false`                    |
| `redis.auth.enabled`                                        | Whether to enable password authentication with redis                                                | `true`                     |
| `redis.auth.password`                                       | The password redis uses                                                                             | `''`                       |
| `redis.auth.existingSecret`                                 | The name of an existing secret with Redis® credentials                                              | `''`                       |
| `redis.auth.existingSecretPasswordKey`                      | Password key to be retrieved from existing secret                                                   | `''`                       |
| `redis.global.storageClass`                                 | PVC Storage Class  for both Redis&reg; master and replica Persistent Volumes                        | `''`                       |
| `redis.master.persistence.enabled`                          | Enable persistence on Redis&reg; master nodes using Persistent Volume Claims                        | `true`                     |
| `redis.replica.persistence.enabled`                         | Enable persistence on Redis&reg; replica nodes using Persistent Volume Claims                       | `true`                     |
| `cronjob.enabled`                                           | Whether to enable/disable cron jobs sidecar                                                         | `false`                    |
| `cronjob.lifecycle.postStartCommand`                        | Specify deployment lifecycle hook postStartCommand for the cron jobs sidecar                        | `nil`                      |
| `cronjob.lifecycle.preStopCommand`                          | Specify deployment lifecycle hook preStopCommand for the cron jobs sidecar                          | `nil`                      |
| `cronjob.resources`                                         | CPU/Memory resource requests/limits for the cron jobs sidecar                                       | `{}`                       |
| `cronjob.securityContext`                                   | Optional security context for cron jobs sidecar                                                     | `nil`                      |
| `service.type`                                              | Kubernetes Service type                                                                             | `ClusterIP`                |
| `service.loadBalancerIP`                                    | LoadBalancerIp for service type LoadBalancer                                                        | `""`                       |
| `service.annotations`                                       | Annotations for service type                                                                        | `{}`                       |
| `service.nodePort`                                          | NodePort for service type NodePort                                                                  | `nil`                      |
| `service.ipFamilies`                                        | Set ipFamilies as in k8s service objects                                                            | `nil`                      |
| `service.ipFamyPolicy`                                      | define IP protocol bindings as in k8s service objects                                               | `nil`                      |
| `phpClientHttpsFix.enabled`                                 | Sets OVERWRITEPROTOCOL for https ingress redirect                                                   | `false`                    |
| `phpClientHttpsFix.protocol`                                | Sets OVERWRITEPROTOCOL for https ingress redirect                                                   | `https`                    |
| `resources`                                                 | CPU/Memory resource requests/limits                                                                 | `{}`                       |
| `rbac.enabled`                                              | Enable Role and rolebinding for priveledged PSP                                                     | `false`                    |
| `rbac.serviceaccount.create`                                | Wether to create a serviceaccount or use an existing one (requires rbac)                            | `true`                     |
| `rbac.serviceaccount.name`                                  | The name of the sevice account that the deployment will use (requires rbac)                         | `nextcloud-serviceaccount` |
| `rbac.serviceaccount.annotations`                           | Serviceaccount annotations                                                                          | `{}`                       |
| `hpa.enabled`                                               | Boolean to create a HorizontalPodAutoscaler. If set to `true`, ignores `replicaCount`.              | `false`                    |
| `hpa.cputhreshold`                                          | CPU threshold percent for the HorizontalPodAutoscale                                                | `60`                       |
| `hpa.minPods`                                               | Min. pods for the Nextcloud HorizontalPodAutoscaler                                                 | `1`                        |
| `hpa.maxPods`                                               | Max. pods for the Nextcloud HorizontalPodAutoscaler                                                 | `10`                       |
| `deploymentLabels`                                          | Labels to be added at 'deployment' level                                                            | not set                    |
| `deploymentAnnotations`                                     | Annotations to be added at 'deployment' level                                                       | not set                    |
| `podLabels`                                                 | Labels to be added at 'pod' level                                                                   | not set                    |
| `podAnnotations`                                            | Annotations to be added at 'pod' level                                                              | not set                    |
| `dnsConfig`                                                 | Custom dnsConfig for nextcloud containers                                                           | `{}`                       |

### Database Configurations
By default, nextcloud will use a SQLite database. This is not recommended for production, but is enabled by default for testing purposes. When you are done testing, please set `internalDatabase.enabled` to `false`, and configure the `externalDatabase` parameters below.

For convenience, we packages the following Bitnami charts for databases (feel free to choose _one_ below):
- [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb)
- [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)

If you choose to use one of the prepackaged Bitnami helm charts, you must configure both the `externalDatabase` parameters, and the parameters for the chart you choose. For instance, if you choose to use the Bitnami PostgreSQL chart that we've prepackaged, you need to also configure all the parameters for `postgresql`. You do not need to use the Bitnami helm charts. If you want to use an already configured database that you have externally, just set `internalDatabase.enabled` to `false`, and configure the `externalDatabase` parameters below.


| Parameter                                                             | Description                                                                       | Default                |
|-----------------------------------------------------------------------|-----------------------------------------------------------------------------------|------------------------|
| `internalDatabase.enabled`                                            | Whether to use internal sqlite database                                           | `true`                 |
| `internalDatabase.database`                                           | Name of the existing database                                                     | `nextcloud`            |
| `externalDatabase.enabled`                                            | Whether to use external database                                                  | `false`                |
| `externalDatabase.type`                                               | External database type: `mysql`, `postgresql`                                     | `mysql`                |
| `externalDatabase.host`                                               | Host of the external database in form of `host:port`                              | `nil`                  |
| `externalDatabase.database`                                           | Name of the existing database                                                     | `nextcloud`            |
| `externalDatabase.user`                                               | Existing username in the external db                                              | `nextcloud`            |
| `externalDatabase.password`                                           | Password for the above username                                                   | `nil`                  |
| `externalDatabase.existingSecret.enabled`                             | Whether to use a existing secret or not                                           | `false`                |
| `externalDatabase.existingSecret.secretName`                          | Name of the existing secret                                                       | `nil`                  |
| `externalDatabase.existingSecret.usernameKey`                         | Name of the key that contains the username                                        | `nil`                  |
| `externalDatabase.existingSecret.passwordKey`                         | Name of the key that contains the password                                        | `nil`                  |
| `externalDatabase.existingSecret.hostKey`                             | Name of the key that contains the database hostname or IP address                 | `nil`                  |
| `externalDatabase.existingSecret.databaseKey`                         | Name of the key that contains the database name                                   | `nil`                  |
| `mariadb.enabled`                                                     | Whether to use the MariaDB chart                                                  | `false`                |
| `mariadb.auth.database`                                               | Database name to create                                                           | `nextcloud`            |
| `mariadb.auth.username`                                               | Database user to create                                                           | `nextcloud`            |
| `mariadb.auth.password`                                               | Password for the database                                                         | `changeme`             |
| `mariadb.auth.rootPassword`                                           | MariaDB admin password                                                            | `nil`                  |
| `mariadb.auth.existingSecret`                                         | Use existing secret for MariaDB password details; see values.yaml for more detail | `''`                   |
| `mariadb.image.registry`                                              | MariaDB image registry                                                            | `docker.io`            |
| `mariadb.image.repository`                                            | MariaDB image repository                                                          | `bitnami/mariadb`      |
| `mariadb.image.tag`                                                   | MariaDB image tag                                                                 | ``                     |
| `mariadb.global.defaultStorageClass`                                  | MariaDB Global default StorageClass for Persistent Volume(s)                      | `''`                   |
| `mariadb.primary.persistence.enabled`                                 | Whether or not to Use a PVC on MariaDB primary                                    | `false`                |
| `mariadb.primary.persistence.storageClass`                            | MariaDB primary persistent volume storage Class                                   | `''`                   |
| `mariadb.primary.persistence.existingClaim`                           | Use an existing PVC for MariaDB primary                                           | `''`                   |
| `postgresql.enabled`                                                  | Whether to use the PostgreSQL chart                                               | `false`                |
| `postgresql.image.registry`                                           | PostgreSQL image registry                                                         | `docker.io`            |
| `postgresql.image.repository`                                         | PostgreSQL image repository                                                       | `bitnami/postgresql`   |
| `postgresql.image.tag`                                                | PostgreSQL image tag                                                              | `15.4.0-debian-11-r10` |
| `postgresql.global.postgresql.auth.database`                          | Database name to create                                                           | `nextcloud`            |
| `postgresql.global.postgresql.auth.username`                          | Database user to create                                                           | `nextcloud`            |
| `postgresql.global.postgresql.auth.password`                          | Password for the database                                                         | `changeme`             |
| `postgresql.global.postgresql.auth.existingSecret`                    | Name of existing secret to use for PostgreSQL credentials                         | `''`                   |
| `postgresql.global.postgresql.auth.secretKeys.adminPasswordKey`       | Name of key in existing secret to use for PostgreSQL admin password               | `''`                   |
| `postgresql.global.postgresql.auth.secretKeys.userPasswordKey`        | Name of key in existing secret to use for PostgreSQL user password                | `''`                   |
| `postgresql.global.postgresql.auth.secretKeys.replicationPasswordKey` | Name of key in existing secret to use for PostgreSQL replication password         | `''`                   |
| `postgresql.primary.persistence.enabled`                              | Whether or not to use PVC on PostgreSQL primary                                   | `false`                |
| `postgresql.primary.persistence.existingClaim`                        | Use an existing PVC for PostgreSQL primary                                        | `nil`                  |

Is there a missing parameter for one of the Bitnami helm charts listed above? Please feel free to submit a PR to add that parameter in our values.yaml, but be sure to also update this README file :)


### Object Storage as Primary Storage Configuration

Nextcloud allows to configure object storages like OpenStack Swift or Amazon Simple Storage Service (S3) or any compatible S3-implementation (e.g. Minio or Ceph Object Gateway) as primary storage replacing the default storage of files.

By default, files are stored in nextcloud/data or another directory configured in the config.php of your Nextcloud instance. This data directory might still be used for compatibility reasons)

Read more in the official [docs](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/primary_storage.html#configuring-object-storage-as-primary-storage).

Here are all the values you can currently configure in this helm chart to configure an Object Store as your Primary Storage.


| Parameter                                       | Description                                                           | Default     |
|-------------------------------------------------|-----------------------------------------------------------------------|-------------|
| `nextcloud.objectStore.s3.enabled`              | enable configuring S3 as a primary object store                       | `false`     |
| `nextcloud.objectStore.s3.accessKey`            | accessKeyID for authing to S3, ignored if using existinSecret         | `''`        |
| `nextcloud.objectStore.s3.secretKey`            | secretAccessKey for authing to S3, ignored if using existinSecret     | `''`        |
| `nextcloud.objectStore.s3.legacyAuth`           | use legacy authentication for S3                                      | `false`     |
| `nextcloud.objectStore.s3.host`                 | endpoint URL to connect to. Only required if not using AWS            | `''`        |
| `nextcloud.objectStore.s3.ssl`                  | Use TLS connection when connecting to S3                              | `true`      |
| `nextcloud.objectStore.s3.port`                 | Port for S3 host to use                                               | `443`       |
| `nextcloud.objectStore.s3.region`               | region to look for bucket in on the S3 host                           | `eu-west-1` |
| `nextcloud.objectStore.s3.bucket`               | bucket on the S3 host                                                 | `''`        |
| `nextcloud.objectStore.s3.prefix`               | optional object prefix                                                | `''`        |
| `nextcloud.objectStore.s3.usePathStyle`         | set to true if you are not using DNS for your buckets                 | `false`     |
| `nextcloud.objectStore.s3.autoCreate`           | auto-create the S3 bucket                                             | `false`     |
| `nextcloud.objectStore.s3.storageClass`         | S3 storage class to use                                               | `STANDARD`  |
| `nextcloud.objectStore.s3.sse_c_key`            | S3 server side encryption key.                                        | `''`        |
| `nextcloud.objectStore.s3.existingSecret`       | Use an existing Kubernetes Secret to fetch auth credentials           | `''`        |
| `nextcloud.objectStore.s3.secretKeys.host`      | if using s3.existingSecret, secret key to use for the host            | `''`        |
| `nextcloud.objectStore.s3.secretKeys.accessKey` | if using s3.existingSecret, secret key to use for the accessKeyID     | `''`        |
| `nextcloud.objectStore.s3.secretKeys.secretKey` | if using s3.existingSecret, secret key to use for the secretAccessKey | `''`        |
| `nextcloud.objectStore.s3.secretKeys.bucket`    | if using s3.existingSecret, secret key to use for the bucket          | `''`        |
| `nextcloud.objectStore.s3.secretKeys.sse_c_key` | if using s3.existingSecret, secret key to use for the sse_c_key       | `''`        |
| `nextcloud.objectStore.swift.enabled`           | enable configuring Openstack Swift as a primary object store          | `false`     |
| `nextcloud.objectStore.swift.user.domain`       | optional: swift user domain                                           | `'Default'` |
| `nextcloud.objectStore.swift.user.name`         | Swift username                                                        | `''`        |
| `nextcloud.objectStore.swift.user.password`     | Swift user password                                                   | `''`        |
| `nextcloud.objectStore.swift.project.name`      | Swift project name                                                    | `''`        |
| `nextcloud.objectStore.swift.project.domain`    | optional: swift project domain                                        | `'Default'` |
| `nextcloud.objectStore.swift.url`               | Swift Identity / Keystone endpoint                                    | `''`        |
| `nextcloud.objectStore.swift.region`            | Swift region                                                          | `''`        |
| `nextcloud.objectStore.swift.service`           | Optional: service name, used on some swift implementations            | `'swift'`   |
| `nextcloud.objectStore.swift.container`         | Swift container to store the data in                                  | `''`        |
| `nextcloud.objectStore.swift.autoCreate`        | Autocreate the Swift container                                        | `false`     |



### Persistence Configurations

The [Nextcloud](https://hub.docker.com/_/nextcloud/) image stores the nextcloud data and configurations at the `/var/www/html` paths of the container.
Persistent Volume Claims are used to keep the data across deployments. This is known to work with GKE, EKS, K3s, and minikube.
Nextcloud will *not* delete the PVCs when uninstalling the helm chart.


| Parameter                                 | Description                                          | Default                                     |
|-------------------------------------------|------------------------------------------------------|---------------------------------------------|
| `persistence.enabled`                     | Enable persistence using PVC                         | `false`                                     |
| `persistence.annotations`                 | PVC annotations                                      | `{}`                                        |
| `persistence.storageClass`                | PVC Storage Class for nextcloud volume               | `nil` (uses alpha storage class annotation) |
| `persistence.existingClaim`               | An Existing PVC name for nextcloud volume            | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`                  | PVC Access Mode for nextcloud volume                 | `ReadWriteOnce`                             |
| `persistence.size`                        | PVC Storage Request for nextcloud volume             | `8Gi`                                       |
| `persistence.nextcloudData.enabled`       | Create a second PVC for the data folder in nextcloud | `false`                                     |
| `persistence.nextcloudData.annotations`   | see `persistence.annotations`                        | `{}`                                        |
| `persistence.nextcloudData.storageClass`  | see `persistence.storageClass`                       | `nil` (uses alpha storage class annotation) |
| `persistence.nextcloudData.existingClaim` | see `persistence.existingClaim`                      | `nil` (uses alpha storage class annotation) |
| `persistence.nextcloudData.accessMode`    | see `persistence.accessMode`                         | `ReadWriteOnce`                             |
| `persistence.nextcloudData.size`          | see `persistence.size`                               | `8Gi`                                       |


### Metrics Configurations

We include an optional experimental Nextcloud Metrics exporter from [xperimental/nextcloud-exporter](https://github.com/xperimental/nextcloud-exporter).

| Parameter                              | Description                                                                         | Default                                                      |
|----------------------------------------|-------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                      | Start Prometheus metrics exporter                                                   | `false`                                                      |
| `metrics.replicaCount`                 | Number of nextcloud-metrics pod replicas to deploy                                  | `1`                                                          |
| `metrics.server`                       | Nextcloud Server URL to get metrics from. If not provided, defaults to service name | `""`                                                         |
| `metrics.https`                        | Defines if https is used to connect to nextcloud                                    | `false` (uses http)                                          |
| `metrics.token`                        | Uses token for auth instead of username/password                                    | `""`                                                         |
| `metrics.timeout`                      | When the scrape times out                                                           | `5s`                                                         |
| `metrics.tlsSkipVerify`                | Skips certificate verification of Nextcloud server                                  | `false`                                                      |
| `metrics.info.apps`                    | Enable gathering of apps-related metrics.                                           | `false`                                                      |
| `metrics.image.repository`             | Nextcloud metrics exporter image name                                               | `xperimental/nextcloud-exporter`                             |
| `metrics.image.tag`                    | Nextcloud metrics exporter image tag                                                | `0.6.2`                                                      |
| `metrics.image.pullPolicy`             | Nextcloud metrics exporter image pull policy                                        | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`            | Nextcloud metrics exporter image pull secrets                                       | `nil`                                                        |
| `metrics.podAnnotations`               | Additional annotations for metrics exporter                                         | not set                                                      |
| `metrics.podLabels`                    | Additional labels for metrics exporter                                              | not set                                                      |
| `metrics.service.type`                 | Metrics: Kubernetes Service type                                                    | `ClusterIP`                                                  |
| `metrics.service.loadBalancerIP`       | Metrics: LoadBalancerIp for service type LoadBalancer                               | `nil`                                                        |
| `metrics.service.nodePort`             | Metrics: NodePort for service type NodePort                                         | `nil`                                                        |
| `metrics.service.annotations`          | Additional annotations for service metrics exporter                                 | `{prometheus.io/scrape: "true", prometheus.io/port: "9205"}` |
| `metrics.service.labels`               | Additional labels for service metrics exporter                                      | `{}`                                                         |
| `metrics.serviceMonitor.enabled`       | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator        | `false`                                                      |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                            | ``                                                           |
| `metrics.serviceMonitor.jobLabel`      | Name of the label on the target service to use as the job name in prometheus        | ``                                                           |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped                                         | `30s`                                                        |
| `metrics.serviceMonitor.scrapeTimeout` | Specify the timeout after which the scrape is ended                                 | ``                                                           |
| `metrics.serviceMonitor.labels`        | Extra labels for the ServiceMonitor                                                 | `{}                                                          |



> **Note**:
>
> For nextcloud to function correctly, you should specify the `nextcloud.host` parameter to specify the FQDN (recommended) or the public IP address of the nextcloud service.
>
> Optionally, you can specify the `service.loadBalancerIP` parameter to assign a reserved IP address to the nextcloud service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> gcloud compute addresses create nextcloud-public-ip
> ```
>
> The reserved IP address can be associated to the nextcloud service by specifying it as the value of the `service.loadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install --name my-release \
  --set nextcloud.username=admin,nextcloud.password=password,mariadb.auth.rootPassword=secretpassword \
    nextcloud/nextcloud
```

The above command sets the nextcloud administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml nextcloud/nextcloud
```

> **Tip**: You can use the default [values.yaml](values.yaml)


### Probes Configurations

The nextcloud deployment includes a series of different probes you can use to determine if a pod is ready or not. You can learn more in the [Configure Liveness, Readiness and Startup Probes Kubernetes docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/).


| Parameter                            | Description                                 | Default |
|--------------------------------------|---------------------------------------------|---------|
| `livenessProbe.enabled`              | Turn on and off liveness probe              | `true`  |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated    | `10`    |
| `livenessProbe.periodSeconds`        | How often to perform the probe              | `10`    |
| `livenessProbe.timeoutSeconds`       | When the probe times out                    | `5`     |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe  | `3`     |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe | `1`     |
| `readinessProbe.enabled`             | Turn on and off readiness probe             | `true`  |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated   | `10`    |
| `readinessProbe.periodSeconds`       | How often to perform the probe              | `10`    |
| `readinessProbe.timeoutSeconds`      | When the probe times out                    | `5`     |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe  | `3`     |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe | `1`     |
| `startupProbe.enabled`               | Turn on and off startup probe               | `false` |
| `startupProbe.initialDelaySeconds`   | Delay before readiness probe is initiated   | `30`    |
| `startupProbe.periodSeconds`         | How often to perform the probe              | `10`    |
| `startupProbe.timeoutSeconds`        | When the probe times out                    | `5`     |
| `startupProbe.failureThreshold`      | Minimum consecutive failures for the probe  | `30`    |
| `startupProbe.successThreshold`      | Minimum consecutive successes for the probe | `1`     |

> [!Note]
> If you are getting errors on initialization (such as `Fatal error: require_once(): Failed opening required '/var/www/html/lib/versioncheck.php'`, but you can get other errors as well), a good first step is to try and enable the startupProbe and/or increase the `initialDelaySeconds` for the `livenessProbe` and `readinessProbe` to something much greater (consider using `120` seconds instead of `10`. This is an especially good idea if your cluster is running on older hardware, has a slow internet connection, or you're using a slower storage class, such as NFS that's running with older disks or a slow connection.

## Cron jobs

To execute [background tasks](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/background_jobs_configuration.html) by using system cron instead of default Ajax cron, set `cronjob.enabled` parameter to `true`. Background jobs are important for tasks that do not necessarily need user intervention, but still need to be executed frequently (cleaning up, sending some notifications, pulling RSS feeds, etc.).

Enabling this option will create a sidecar container in the Nextcloud pod, which will start a [`crond` daemon](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/background_jobs_configuration.html#cron) responsible for running the Nextcloud cron.php script. At first launch, the background jobs mode in your Nextcloud basic settings will automatically be set to ***Cron***.


## Using the nextcloud docker image auto-configuration via env vars

The [nextcloud/docker](https://github.com/nextcloud/docker/tree/master) image provides an auto-configuration via environment variables. See [their docs](https://github.com/nextcloud/docker/tree/master#auto-configuration-via-environment-variables) for more info.


## Multiple config.php file

Nextcloud supports loading configuration parameters from multiple files.
You can add arbitrary files ending with `.config.php` in the `config/` directory.
See [documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#multiple-config-php-file). For example, to enable image and document previews:


```yaml
nextcloud:
  configs:
    previews.config.php: |-
      <?php
      $CONFIG = array (
        'enable_previews' => true,
        'enabledPreviewProviders' => array (
          'OC\Preview\Movie',
          'OC\Preview\PNG',
          'OC\Preview\JPEG',
          'OC\Preview\GIF',
          'OC\Preview\BMP',
          'OC\Preview\XBitmap',
          'OC\Preview\MP3',
          'OC\Preview\MP4',
          'OC\Preview\TXT',
          'OC\Preview\MarkDown',
          'OC\Preview\PDF'
        ),
      );
```

## Using nginx
To use nginx instead of apache to serve nextcloud, Set the following parameters in your `values.yaml`:

```yaml
# This Generates an image tag using the chart's app version
# e.g. if the app version is 25.0.3, the image tag will be 25.0.3-fpm
image:
  flavor: fpm
  # You can also specify a tag directly. this version is an example:
  # tag: 25.0.3-fpm
```

```yaml
# this deploys an nginx container within the nextcloud pod
nginx
  enabled: true
```

### Service discovery with nginx and ingress

For service discovery (CalDAV, CardDAV, webfinger, nodeinfo) to work you need to add redirects to your ingress.
If you use the [ingress-nginx](https://github.com/kubernetes/ingress-nginx) you can use the following server snippet annotation:

<!-- Keep this in sync with the values.yaml -->
```yaml
ingress:
  annotations:
    nginx.ingress.kubernetes.io/server-snippet: |-
      server_tokens off;
      proxy_hide_header X-Powered-By;
      rewrite ^/.well-known/webfinger /index.php/.well-known/webfinger last;
      rewrite ^/.well-known/nodeinfo /index.php/.well-known/nodeinfo last;
      rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
      rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json;
      location = /.well-known/carddav {
        return 301 $scheme://$host/remote.php/dav;
      }
      location = /.well-known/caldav {
        return 301 $scheme://$host/remote.php/dav;
      }
      location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
      }
      location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
        deny all;
      }
      location ~ ^/(?:autotest|occ|issue|indie|db_|console) {
        deny all;
      }
```
## Preserving Source IP

- Make sure your loadbalancer preserves source IP, for bare metal, `metalb` does and `klipper-lb` doesn't.
- Make sure your Ingress preserves source IP. If you use `ingress-nginx`, add the following annotations:
```yaml
ingress:
  annotations:
   nginx.ingress.kubernetes.io/enable-cors: "true"
   nginx.ingress.kubernetes.io/cors-allow-headers: "X-Forwarded-For"
```
- The next layer is nextcloud pod's nginx container. In in your `values.yaml`, if `nextcloud.tag` has `fpm` in it, or `image.flavor` is set to `fpm`, this can be left at default
- Add some PHP config for nextcloud as mentioned above in multiple `config.php`s section:
```php
  configs:
    proxy.config.php: |-
      <?php
      $CONFIG = array (
        'trusted_proxies' => array(
          0 => '127.0.0.1',
          1 => '10.0.0.0/8',
        ),
        'forwarded_for_headers' => array('HTTP_X_FORWARDED_FOR'),
      );
```

## Hugepages

If your node has hugepages enabled, but you do not map any into the container, it could fail to start with a bus error in Apache. This is due
to Apache attempting to memory map a file and use hugepages. The fix is to either disable huge pages on the node or map hugepages into the container:

```yaml
nextcloud:
  extraVolumes:
    - name: hugepages
      emptyDir:
        medium: HugePages-2Mi
  extraVolumeMounts:
    - name: hugepages
      mountPath: /dev/hugepages
resources:
  requests:
    hugepages-2Mi: 500Mi
    # note that Kubernetes currently requires cpu or memory requests and limits before hugepages are allowed.
    memory: 500Mi
  limits:
    # limit and request must be the same for hugepages. They are a fixed resource.
    hugepages-2Mi: 500Mi
    # note that Kubernetes currently requires cpu or memory requests and limits before hugepages are allowed.
    memory: 1Gi
```

## HPA (Clustering)
If you want to have multiple Nextcloud containers, regardless of dynamic or static sizes, you need to use shared persistence between the containers.

Minimum cluster compatible persistence settings:
```yaml
persistence:
  enabled: true
  accessMode: ReadWriteMany
```

## Adjusting PHP ini values

Sometimes you may need special [`php.ini`](https://www.php.net/manual/en/ini.list.php) values. For instance, perhaps your setup requires a bit more memory. You can add additional `php.ini` files in the values.yaml by providing `nextcloud.phpConfigs.NAME_OF_FILE`. Here's an examples:

```yaml
nextcloud:
  phpConfigs:
    zz-memory_limit.ini: |-
      memory_limit=512M
```

> [!Note]
> Be sure to prefix your file name with `zz` to ensure it is loaded at the end.


## Running `occ` commands
Sometimes you need to run an [occ](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html) command on the Nextcloud container directly. You can do that by running commands as the user `www-data` via the `kubectl exec` command.

```bash
# $NEXTCLOUD_POD should be the name of *your* nextcloud pod :)
kubectl exec $NEXTCLOUD_POD -- su -s /bin/sh www-data -c "php occ myocccomand"
```

Here are some examples below.

### Putting Nextcloud into maintanence mode
Some admin actions require you to put your Nextcloud instance into [maintanence mode](https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html#maintenance-mode) (e.g. backups):

```bash
# $NEXTCLOUD_POD should be the name of *your* nextcloud pod :)
kubectl exec $NEXTCLOUD_POD -- su -s /bin/sh www-data -c "php occ maintenance:mode --on"
```

### Downloading models for recognize
[Recognize](https://github.com/nextcloud/recognize) requires you to download models before using it:

```bash
# $NEXTCLOUD_POD should be the name of *your* nextcloud pod :)
kubectl exec $NEXTCLOUD_POD -- su -s /bin/sh www-data -c "php occ recognize:download-models"
```

# Backups
Check out the [official Nextcloud backup docs](https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html). For your files, if you're using persistent volumes, and you'd like to back up to s3 backed storage (such as minio), consider using [k8up](https://github.com/k8up-io/k8up) or [velero](https://github.com/vmware-tanzu/velero).

# Upgrades
Since this chart utilizes the [nextcloud/docker](https://github.com/nextcloud/docker) image, provided you are using persistent volumes, [upgrades of your Nextcloud server are handled automatically](https://github.com/nextcloud/docker#update-to-a-newer-version) from one version to the next, however, you can only upgrade one major version at a time. For example, if you want to upgrade from version `25` to `27`, you will have to upgrade from version `25` to `26`, then from `26` to `27`. Since our docker tag is set via the [`appVersion` in `Chart.yaml`](https://github.com/nextcloud/helm/blob/main/charts/nextcloud/Chart.yaml#L4), you'll need to make sure you gradually upgrade the helm chart if you have missed serveral app versions.

⚠️ *Before Upgrading Nextcloud or the attached database, always make sure you take [backups](#backups)!*

After an upgrade, you may have missing indices. To fix this, you can run:

```bash
# where NEXTCLOUD_POD is *your* nextcloud pod
kubectl exec -it $NEXTCLOUD_POD -- su -s /bin/sh www-data -c "php occ db:add-missing-indices"
```

# Troubleshooting

## Logging
The nextcloud instance deployed by this chart doesn't currently create a log file locally inside the container.
Examples scenarios to change this behavior include:
 - Triaging mailserver issues
 - Any time you're confused by server behavior and need more context
 - Before submitting a GitHub Issue (you can include relevant log messages that way)

### Changing the logging behavior
To change the logging behavior, modify your `logging.config.php` in your `values.yaml` under the `nextcloud.configs` section like so:
```yaml
nextcloud:
  configs:
    logging.config.php: |-
      <?php
      $CONFIG = array (
        'log_type' => 'file',
        'logfile' => 'nextcloud.log',
        'loglevel' => 0,
        'logdateformat' => 'F d, Y H:i:s'
        );
```
`loglevel` corresponds to the detail of the logs. Valid values are:
```
0: DEBUG: All activity; the most detailed logging.

1: INFO: Activity such as user logins and file activities, plus warnings, errors, and fatal errors.

2: WARN: Operations succeed, but with warnings of potential problems, plus errors and fatal errors.

3: ERROR: An operation fails, but other services and operations continue, plus fatal errors.

4: FATAL: The server stops.
```
[More information about Nextcloud logging](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/logging_configuration.html)

### Viewing the logs
To view logs after changing the logging behavior, you can exec into the Kubernetes pod, or copy them to your local machine.

#### Exec into the kubernetes pod:
```bash
kubectl exec --stdin --tty nextcloud-pod-name-random-chars -- /bin/sh
```

#### Then look for the `nextcloud.log` file with tail or cat:

```bash
cat nextcloud.log
tail -f nextcloud.log
```

#### Copy the log file to your local machine:
```bash
kubectl cp default/nextcloud-pod-name-random-chars:nextcloud.log ./my-local-machine-nextcloud.log
```

### Sharing the logs
Remember to anonymize your logs and snippets from your pod before sharing them with the internet. Kubernetes secrets, even Sealed ones, live in plaintext `env` variables on your running containers, and log messages can include other information that should stay safely with you.
