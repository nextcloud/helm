# nextcloud

[nextcloud](https://nextcloud.com/) is a file sharing server that puts the control and security of your own data back into your hands.

## TL;DR;

```console
helm repo add nextcloud https://nextcloud.github.io/helm/
helm install my-release nextcloud/nextcloud
```

## Introduction

This chart bootstraps an [nextcloud](https://hub.docker.com/_/nextcloud/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

You will also need a database compatible with Nextcloud. For more info, please see the [Database Configuration](#database-configurations) section below.

If you want to persist data accross installs and upgrades, you'll need to configure persistence. For more info, please see the [Persistence Configuration](#persistence-configurations) section below.

We also package a Redis helm chart as an _optional_ caching system from Bitnami:
- [Bitnami Redis Chart](https://github.com/bitnami/charts/tree/main/bitnami/redis)

## Prerequisites

- Kubernetes 1.20+
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

| Parameter                                                            | Description                                                                            | Default                                      |
|----------------------------------------------------------------------|----------------------------------------------------------------------------------------|----------------------------------------------|
| `image.repository`                                                   | nextcloud Image name                                                                   | `nextcloud`                                  |
| `image.flavor`                                                       | nextcloud Image type (Options: apache, fpm)                                            | `apache`                                     |
| `image.tag`                                                          | nextcloud Image tag                                                                    | `{VERSION}`                                  |
| `image.pullPolicy`                                                   | Image pull policy                                                                      | `IfNotPresent`                               |
| `image.pullSecrets`                                                  | Specify image pull secrets                                                             | `nil`                                        |
| `replicaCount`                                                       | Number of nextcloud pods to deploy                                                     | `1`                                          |
| `ingress.className`                                                  | Name of the ingress class to use                                                       | `nil`                                        |
| `ingress.enabled`                                                    | Enable use of ingress controllers                                                      | `false`                                      |
| `ingress.servicePort`                                                | Ingress' backend servicePort                                                           | `http`                                       |
| `ingress.annotations`                                                | An array of service annotations                                                        | `nil`                                        |
| `ingress.labels`                                                     | An array of service labels                                                             | `nil`                                        |
| `ingress.path`                                                       | The `Path` to use in Ingress' `paths`                                                  | `/`                                          |
| `ingress.pathType`                                                   | The `PathType` to use in Ingress' `paths`                                              | `Prefix`                                     |
| `ingress.tls`                                                        | Ingress TLS configuration                                                              | `[]`                                         |
| `nextcloud.host`                                                     | nextcloud host to create application URLs                                              | `nextcloud.kube.home`                        |
| `nextcloud.username`                                                 | User of the application                                                                | `admin`                                      |
| `nextcloud.password`                                                 | Application password                                                                   | `changeme`                                   |
| `nextcloud.existingSecret.enabled`                                   | Whether to use an existing secret or not                                               | `false`                                      |
| `nextcloud.existingSecret.secretName`                                | Name of the existing secret                                                            | `nil`                                        |
| `nextcloud.existingSecret.usernameKey`                               | Name of the key that contains the username                                             | `nil`                                        |
| `nextcloud.existingSecret.passwordKey`                               | Name of the key that contains the password                                             | `nil`                                        |
| `nextcloud.existingSecret.smtpUsernameKey`                           | Name of the key that contains the SMTP username                                        | `nil`                                        |
| `nextcloud.existingSecret.smtpPasswordKey`                           | Name of the key that contains the SMTP password                                        | `nil`                                        |
| `nextcloud.update`                                                   | Trigger update if custom command is used                                               | `0`                                          |
| `nextcloud.containerPort`                                            | Customize container port when not running as root                                      | `80`                                         |
| `nextcloud.datadir`                                                  | nextcloud data dir location                                                            | `/var/www/html/data`                         |
| `nextcloud.mail.enabled`                                             | Whether to enable/disable email settings                                               | `false`                                      |
| `nextcloud.mail.fromAddress`                                         | nextcloud mail send from field                                                         | `nil`                                        |
| `nextcloud.mail.domain`                                              | nextcloud mail domain                                                                  | `nil`                                        |
| `nextcloud.mail.smtp.host`                                           | SMTP hostname                                                                          | `nil`                                        |
| `nextcloud.mail.smtp.secure`                                         | SMTP connection `ssl` or empty                                                         | `''`                                         |
| `nextcloud.mail.smtp.port`                                           | Optional SMTP port                                                                     | `nil`                                        |
| `nextcloud.mail.smtp.authtype`                                       | SMTP authentication method                                                             | `LOGIN`                                      |
| `nextcloud.mail.smtp.name`                                           | SMTP username                                                                          | `''`                                         |
| `nextcloud.mail.smtp.password`                                       | SMTP password                                                                          | `''`                                         |
| `nextcloud.configs`                                                  | Config files created in `/var/www/html/config`                                         | `{}`                                         |
| `nextcloud.persistence.subPath`                                      | Set the subPath for nextcloud to use in volume                                         | `nil`                                        |
| `nextcloud.phpConfigs`                                               | PHP Config files created in `/usr/local/etc/php/conf.d`                                | `{}`                                         |
| `nextcloud.defaultConfigs.\.htaccess`                                | Default .htaccess to protect `/var/www/html/config`                                    | `true`                                       |
| `nextcloud.defaultConfigs.redis\.config\.php`                        | Default Redis configuration                                                            | `true`                                       |
| `nextcloud.defaultConfigs.apache-pretty-urls\.config\.php`           | Default Apache configuration for rewrite urls                                          | `true`                                       |
| `nextcloud.defaultConfigs.apcu\.config\.php`                         | Default configuration to define APCu as local cache                                    | `true`                                       |
| `nextcloud.defaultConfigs.apps\.config\.php`                         | Default configuration for apps                                                         | `true`                                       |
| `nextcloud.defaultConfigs.autoconfig\.php`                           | Default auto-configuration for databases                                               | `true`                                       |
| `nextcloud.defaultConfigs.smtp\.config\.php`                         | Default configuration for smtp                                                         | `true`                                       |
| `nextcloud.strategy`                                                 | specifies the strategy used to replace old Pods by new ones                            | `type: Recreate`                             |
| `nextcloud.extraEnv`                                                 | specify additional environment variables                                               | `{}`                                         |
| `nextcloud.extraSidecarContainers`                                   | specify additional sidecar containers                                                  | `[]`                                         |
| `nextcloud.extraInitContainers`                                      | specify additional init containers                                                     | `[]`                                         |
| `nextcloud.extraVolumes`                                             | specify additional volumes for the NextCloud pod                                       | `{}`                                         |
| `nextcloud.extraVolumeMounts`                                        | specify additional volume mounts for the NextCloud pod                                 | `{}`                                         |
| `nextcloud.securityContext`                                          | Optional security context for the NextCloud container                                  | `nil`                                        |
| `nextcloud.podSecurityContext`                                       | Optional security context for the NextCloud pod (applies to all containers in the pod) | `nil`                                        |
| `nginx.enabled`                                                      | Enable nginx (requires you use php-fpm image)                                          | `false`                                      |
| `nginx.image.repository`                                             | nginx Image name                                                                       | `nginx`                                      |
| `nginx.image.tag`                                                    | nginx Image tag                                                                        | `alpine`                                     |
| `nginx.image.pullPolicy`                                             | nginx Image pull policy                                                                | `IfNotPresent`                               |
| `nginx.config.default`                                               | Whether to use nextcloud's recommended nginx config                                    | `true`                                       |
| `nginx.config.custom`                                                | Specify a custom config for nginx                                                      | `{}`                                         |
| `nginx.resources`                                                    | nginx resources                                                                        | `{}`                                         |
| `nginx.securityContext`                                              | Optional security context for the nginx container                                      | `nil`                                        |
| `lifecycle.postStartCommand`                                         | Specify deployment lifecycle hook postStartCommand                                     | `nil`                                        |
| `lifecycle.preStopCommand`                                           | Specify deployment lifecycle hook preStopCommand                                       | `nil`                                        |
| `redis.enabled`                                                      | Whether to install/use redis for locking                                               | `false`                                      |
| `redis.auth.enabled`                                                 | Whether to enable password authentication with redis                                   | `true`                                       |
| `redis.auth.password`                                                | The password redis uses                                                                | `''`                                         |
| `redis.auth.existingSecret`                                          | The name of an existing secret with Redis® credentials                                 | `''`                                         |
| `redis.auth.existingSecretPasswordKey`                               | Password key to be retrieved from existing secret                                      | `''`                                         |
| `cronjob.enabled`                                                    | Whether to enable/disable cronjob                                                      | `false`                                      |
| `cronjob.lifecycle.postStartCommand`                                 | Specify deployment lifecycle hook postStartCommand                                     | `nil`                                        |
| `cronjob.lifecycle.preStopCommand`                                   | Specify deployment lifecycle hook preStopCommand                                       | `nil`                                        |
| `cronjob.resources`                                                  | CPU/Memory resource requests/limits for the cronjob sidecar                            | `{}`                                         |
| `cronjob.securityContext`                                            | Optional security context for cronjob                                                  | `nil`                                        |
| `service.type`                                                       | Kubernetes Service type                                                                | `ClusterIP`                                  |
| `service.loadBalancerIP`                                             | LoadBalancerIp for service type LoadBalancer                                           | `nil`                                        |
| `service.nodePort`                                                   | NodePort for service type NodePort                                                     | `nil`                                        |
| `phpClientHttpsFix.enabled`                                          | Sets OVERWRITEPROTOCOL for https ingress redirect                                      | `false`                                      |
| `phpClientHttpsFix.protocol`                                         | Sets OVERWRITEPROTOCOL for https ingress redirect                                      | `https`                                      |
| `resources`                                                          | CPU/Memory resource requests/limits                                                    | `{}`                                         |
| `rbac.enabled`                                                       | Enable Role and rolebinding for priveledged PSP                                        | `false`                                      |
| `rbac.serviceaccount.create`                                         | Wether to create a serviceaccount or use an existing one (requires rbac)               | `true`                                       |
| `rbac.serviceaccount.name`                                           | The name of the sevice account that the deployment will use (requires rbac)            | `nextcloud-serviceaccount`                   |
| `rbac.serviceaccount.annotations`                                    | Serviceaccount annotations                                                             | `{}`                                         |
| `livenessProbe.enabled`                                              | Turn on and off liveness probe                                                         | `true`                                       |
| `livenessProbe.initialDelaySeconds`                                  | Delay before liveness probe is initiated                                               | `10`                                         |
| `livenessProbe.periodSeconds`                                        | How often to perform the probe                                                         | `10`                                         |
| `livenessProbe.timeoutSeconds`                                       | When the probe times out                                                               | `5`                                          |
| `livenessProbe.failureThreshold`                                     | Minimum consecutive failures for the probe                                             | `3`                                          |
| `livenessProbe.successThreshold`                                     | Minimum consecutive successes for the probe                                            | `1`                                          |
| `readinessProbe.enabled`                                             | Turn on and off readiness probe                                                        | `true`                                       |
| `readinessProbe.initialDelaySeconds`                                 | Delay before readiness probe is initiated                                              | `10`                                         |
| `readinessProbe.periodSeconds`                                       | How often to perform the probe                                                         | `10`                                         |
| `readinessProbe.timeoutSeconds`                                      | When the probe times out                                                               | `5`                                          |
| `readinessProbe.failureThreshold`                                    | Minimum consecutive failures for the probe                                             | `3`                                          |
| `readinessProbe.successThreshold`                                    | Minimum consecutive successes for the probe                                            | `1`                                          |
| `startupProbe.enabled`                                               | Turn on and off startup probe                                                          | `false`                                      |
| `startupProbe.initialDelaySeconds`                                   | Delay before readiness probe is initiated                                              | `30`                                         |
| `startupProbe.periodSeconds`                                         | How often to perform the probe                                                         | `10`                                         |
| `startupProbe.timeoutSeconds`                                        | When the probe times out                                                               | `5`                                          |
| `startupProbe.failureThreshold`                                      | Minimum consecutive failures for the probe                                             | `30`                                         |
| `startupProbe.successThreshold`                                      | Minimum consecutive successes for the probe                                            | `1`                                          |
| `hpa.enabled`                                                        | Boolean to create a HorizontalPodAutoscaler                                            | `false`                                      |
| `hpa.cputhreshold`                                                   | CPU threshold percent for the HorizontalPodAutoscale                                   | `60`                                         |
| `hpa.minPods`                                                        | Min. pods for the Nextcloud HorizontalPodAutoscaler                                    | `1`                                          |
| `hpa.maxPods`                                                        | Max. pods for the Nextcloud HorizontalPodAutoscaler                                    | `10`                                         |
| `deploymentLabels`                                                   | Labels to be added at 'deployment' level                                               | not set                                      |
| `deploymentAnnotations`                                              | Annotations to be added at 'deployment' level                                          | not set                                      |
| `podLabels`                                                          | Labels to be added at 'pod' level                                                      | not set                                      |
| `podAnnotations`                                                     | Annotations to be added at 'pod' level                                                 | not set                                      |


### Database Configurations
By default, nextcloud will use a SQLite database. This is not recommended for production, but is enabled by default for testing purposes. When you are done testing, please set `internalDatabase.enabled` to `false`, and configure the `externalDatabase` parameters below.

For convenience, we packages the following Bitnami charts for databases (feel free to choose _one_ below):
- [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb)
- [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)

If you choose to use one of the prepackaged Bitnami helm charts, you must configure both the `externalDatabase` parameters, and the parameters for the chart you choose. For instance, if you choose to use the Bitnami PostgreSQL chart that we've prepackaged, you need to also configure all the parameters for `postgresql`. You do not need to use the Bitnami helm charts. If you want to use an already configured database that you have externally, just set `internalDatabase.enabled` to `false`, and configure the `externalDatabase` parameters below.


| Parameter                                                            | Description                                                                            | Default         |
|----------------------------------------------------------------------|----------------------------------------------------------------------------------------|-----------------|
| `internalDatabase.enabled`                                           | Whether to use internal sqlite database                                                | `true`          |
| `internalDatabase.database`                                          | Name of the existing database                                                          | `nextcloud`     |
| `externalDatabase.enabled`                                           | Whether to use external database                                                       | `false`         |
| `externalDatabase.type`                                              | External database type: `mysql`, `postgresql`                                          | `mysql`         |
| `externalDatabase.host`                                              | Host of the external database in form of `host:port`                                   | `nil`           |
| `externalDatabase.database`                                          | Name of the existing database                                                          | `nextcloud`     |
| `externalDatabase.user`                                              | Existing username in the external db                                                   | `nextcloud`     |
| `externalDatabase.password`                                          | Password for the above username                                                        | `nil`           |
| `externalDatabase.existingSecret.enabled`                            | Whether to use a existing secret or not                                                | `false`         |
| `externalDatabase.existingSecret.secretName`                         | Name of the existing secret                                                            | `nil`           |
| `externalDatabase.existingSecret.usernameKey`                        | Name of the key that contains the username                                             | `nil`           |
| `externalDatabase.existingSecret.passwordKey`                        | Name of the key that contains the password                                             | `nil`           |
| `mariadb.enabled`                                                    | Whether to use the MariaDB chart                                                       | `false`         |
| `mariadb.auth.database`                                              | Database name to create                                                                | `nextcloud`     |
| `mariadb.auth.username`                                              | Database user to create                                                                | `nextcloud`     |
| `mariadb.auth.password`                                              | Password for the database                                                              | `changeme`      |
| `mariadb.auth.rootPassword`                                          | MariaDB admin password                                                                 | `nil`           |
| `mariadb.auth.existingSecret`                                        | Use existing secret for MariaDB password details; see values.yaml for more detail      | `''`            |
| `mariadb.primary.persistence.enabled`                                | Whether or not to Use a PVC on MariaDB primary                                         | `false`         |
| `mariadb.primary.persistence.existingClaim`                          | Use an existing PVC for MariaDB primary                                                | `nil`           |
| `postgresql.enabled`                                                 | Whether to use the PostgreSQL chart                                                    | `false`         |
| `postgresql.global.postgresql.auth.database`                         | Database name to create                                                                | `nextcloud`     |
| `postgresql.global.postgresql.auth.username`                         | Database user to create                                                                | `nextcloud`     |
| `postgresql.global.postgresql.auth.password`                         | Password for the database                                                              | `changeme`      |
| `postgresql.global.postgresql.auth.existingSecret`                   | Name of existing secret to use for PostgreSQL credentials                              | `''`            |
| `postgresql.global.postgresql.auth.secretKeys.adminPasswordKey`      | Name of key in existing secret to use for PostgreSQL admin password                    | `''`            |
| `postgresql.global.postgresql.auth.secretKeys.userPasswordKey`       | Name of key in existing secret to use for PostgreSQL user password                     | `''`            |
| `postgresql.global.postgresql.auth.secretKeys.replicationPasswordKey`| Name of key in existing secret to use for PostgreSQL replication password              | `''`            |
| `postgresql.primary.persistence.enabled`                             | Whether or not to use PVC on PostgreSQL primary                                        | `false`         |
| `postgresql.primary.persistence.existingClaim`                       | Use an existing PVC for PostgreSQL primary                                             | `nil`           |

Is there a missing parameter for one of the Bitnami helm charts listed above? Please feel free to submit a PR to add that parameter in our values.yaml, but be sure to also update this README file :)


### Persistence Configurations

The [Nextcloud](https://hub.docker.com/_/nextcloud/) image stores the nextcloud data and configurations at the `/var/www/html` paths of the container.
Persistent Volume Claims are used to keep the data across deployments. This is known to work with GKE, EKS, K3s, and minikube.


| Parameter                                                            | Description                                                                            | Default                                      |
|----------------------------------------------------------------------|----------------------------------------------------------------------------------------|----------------------------------------------|
| `persistence.enabled`                                                | Enable persistence using PVC                                                           | `false`                                      |
| `persistence.annotations`                                            | PVC annotations                                                                        | `{}`                                         |
| `persistence.storageClass`                                           | PVC Storage Class for nextcloud volume                                                 | `nil` (uses alpha storage class annotation)  |
| `persistence.existingClaim`                                          | An Existing PVC name for nextcloud volume                                              | `nil` (uses alpha storage class annotation)  |
| `persistence.accessMode`                                             | PVC Access Mode for nextcloud volume                                                   | `ReadWriteOnce`                              |
| `persistence.size`                                                   | PVC Storage Request for nextcloud volume                                               | `8Gi`                                        |
| `persistence.nextcloudData.enabled`                                  | Create a second PVC for the data folder in nextcloud                                   | `false`                                      |
| `persistence.nextcloudData.annotations`                              | see `persistence.annotations`                                                          | `{}`                                         |
| `persistence.nextcloudData.storageClass`                             | see `persistence.storageClass`                                                         | `nil` (uses alpha storage class annotation)  |
| `persistence.nextcloudData.existingClaim`                            | see `persistence.existingClaim`                                                        | `nil` (uses alpha storage class annotation)  |
| `persistence.nextcloudData.accessMode`                               | see `persistence.accessMode`                                                           | `ReadWriteOnce`                              |
| `persistence.nextcloudData.size`                                     | see `persistence.size`                                                                 | `8Gi`                                        |


### Metrics Configurations

We include an optional experimental Nextcloud Metrics exporter from [xperimental/nextcloud-exporter](https://github.com/xperimental/nextcloud-exporter).

| Parameter                              | Description                                                                  | Default                                                      |
|----------------------------------------|------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                      | Start Prometheus metrics exporter                                            | `false`                                                      |
| `metrics.https`                        | Defines if https is used to connect to nextcloud                             | `false` (uses http)                                          |
| `metrics.token`                        | Uses token for auth instead of username/password                             | `""`                                                         |
| `metrics.timeout`                      | When the scrape times out                                                    | `5s`                                                         |
| `metrics.tlsSkipVerify`                | Skips certificate verification of Nextcloud server                           | `false`                                                      |
| `metrics.image.repository`             | Nextcloud metrics exporter image name                                        | `xperimental/nextcloud-exporter`                             |
| `metrics.image.tag`                    | Nextcloud metrics exporter image tag                                         | `0.6.0`                                                      |
| `metrics.image.pullPolicy`             | Nextcloud metrics exporter image pull policy                                 | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`            | Nextcloud metrics exporter image pull secrets                                | `nil`                                                        |
| `metrics.podAnnotations`               | Additional annotations for metrics exporter                                  | not set                                                      |
| `metrics.podLabels`                    | Additional labels for metrics exporter                                       | not set                                                      |
| `metrics.service.type`                 | Metrics: Kubernetes Service type                                             | `ClusterIP`                                                  |
| `metrics.service.loadBalancerIP`       | Metrics: LoadBalancerIp for service type LoadBalancer                        | `nil`                                                        |
| `metrics.service.nodePort`             | Metrics: NodePort for service type NodePort                                  | `nil`                                                        |
| `metrics.service.annotations`          | Additional annotations for service metrics exporter                          | `{prometheus.io/scrape: "true", prometheus.io/port: "9205"}` |
| `metrics.service.labels`               | Additional labels for service metrics exporter                               | `{}`                                                         |
| `metrics.serviceMonitor.enabled`       | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator | `false`                                                      |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                     | ``                                                           |
| `metrics.serviceMonitor.jobLabel`      | Name of the label on the target service to use as the job name in prometheus | ``                                                           |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped                                  | `30s`                                                        |
| `metrics.serviceMonitor.scrapeTimeout` | Specify the timeout after which the scrape is ended                          | ``                                                           |
| `metrics.serviceMonitor.labels`        | Extra labels for the ServiceMonitor                                          | `{}                                                          |



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

## Cronjob

This chart can utilize Kubernetes `CronJob` resource to execute [background tasks](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/background_jobs_configuration.html).

To use this functionality, set `cronjob.enabled` parameter to `true` and switch background mode to Webcron in your nextcloud settings page.
See the [Configuration](#configuration) section for further configuration of the cronjob resource.

> **Note**: For the cronjobs to work correctly, ingress must be also enabled (set `ingress.enabled` to `true`) and `nextcloud.host` has to be publicly resolvable.

## Multiple config.php file

Nextcloud supports loading configuration parameters from multiple files.
You can add arbitrary files ending with `.config.php` in the `config/` directory.
See [documentation](https://docs.nextcloud.com/server/15/admin_manual/configuration_server/config_sample_php_parameters.html#multiple-config-php-file).

For example, following config will configure Nextcloud with [S3 as primary storage](https://docs.nextcloud.com/server/13/admin_manual/configuration_files/primary_storage.html#simple-storage-service-s3) by creating file `/var/www/html/config/s3.config.php`:

```yaml
nextcloud:
  configs:
    s3.config.php: |-
      <?php
      $CONFIG = array (
        'objectstore' => array(
          'class' => '\\OC\\Files\\ObjectStore\\S3',
          'arguments' => array(
            'bucket'     => 'my-bucket',
            'autocreate' => true,
            'key'        => 'xxx',
            'secret'     => 'xxx',
            'region'     => 'us-east-1',
            'use_ssl'    => true
          )
        )
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
