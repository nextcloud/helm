# nextcloud

![Version: 6.6.4](https://img.shields.io/badge/Version-6.6.4-informational?style=flat-square) ![AppVersion: 30.0.5](https://img.shields.io/badge/AppVersion-30.0.5-informational?style=flat-square)

A file sharing server that puts the control and security of your own data back into your hands.

**Homepage:** <https://nextcloud.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| skjnldsv | <skjnldsv@protonmail.com> |  |
| chrisingenhaag | <christian.ingenhaag@googlemail.com> |  |
| billimek | <jeff@billimek.com> |  |
| WrenIX |  | <https://wrenix.eu> |
| jessebot |  | <https://jessebot.work> |

## Source Code

* <https://github.com/nextcloud/helm>
* <https://github.com/nextcloud/docker>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://collaboraonline.github.io/online | collabora(collabora-online) | 1.1.20 |
| oci://registry-1.docker.io/bitnamicharts | mariadb | 18.2.0 |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 15.5.0 |
| oci://registry-1.docker.io/bitnamicharts | redis | 19.6.4 |

## Values

### Collabora

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| collabora.autoscaling.enabled | bool | `false` | enable autocaling, please check collabora README.md first |
| collabora.collabora.aliasgroups | list | `[]` | HTTPS nextcloud domain, if needed |
| collabora.collabora.existingSecret.enabled | bool | `false` | set to true to to get collabora admin credentials from an existin secret if set, ignores collabora.collabora.username and password |
| collabora.collabora.existingSecret.passwordKey | string | `"password"` |  |
| collabora.collabora.existingSecret.secretName | string | `""` | name of existing Kubernetes Secret with collboara admin credentials |
| collabora.collabora.existingSecret.usernameKey | string | `"username"` |  |
| collabora.collabora.extra_params | string | `"--o:ssl.enable=false"` | set extra parameters for collabora you may need to add --o:ssl.termination=true |
| collabora.collabora.password | string | `"examplepass"` | setup admin login credentials, these are ignored if collabora.collabora.existingSecret.enabled=true |
| collabora.collabora.server_name | string | `nil` | Specify server_name when the hostname is not reachable directly for example behind reverse-proxy. example: collabora.domain |
| collabora.collabora.username | string | `"admin"` |  |
| collabora.enabled | bool | `false` | Activate collabora subchart |
| collabora.ingress.annotations | object | `{}` | please check collabora values.yaml for nginx/haproxy annotations examples |
| collabora.ingress.className | string | `""` |  |
| collabora.ingress.enabled | bool | `false` | enable ingress for collabora online |
| collabora.ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | Ingress Host of collabora |
| collabora.ingress.tls | list | `[]` | tls for ingress  - secretName: collabora-ingress-tls    hosts:      - collabora.domain |
| collabora.resources | object | `{}` | see collabora helm README.md for recommended values |

### Database - External

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| externalDatabase.database | string | `"nextcloud"` | Database name |
| externalDatabase.enabled | bool | `false` |  |
| externalDatabase.existingSecret.databaseKey | string | `nil` |  |
| externalDatabase.existingSecret.enabled | bool | `false` |  |
| externalDatabase.existingSecret.hostKey | string | `"db-hostname-or-ip"` |  |
| externalDatabase.existingSecret.passwordKey | string | `"db-password"` |  |
| externalDatabase.existingSecret.secretName | string | `nil` |  |
| externalDatabase.existingSecret.usernameKey | string | `"db-username"` |  |
| externalDatabase.host | string | `""` | Database host. You can optionally include a colon delimited port like "myhost:1234" |
| externalDatabase.password | string | `""` | Database password |
| externalDatabase.type | string | `"mysql"` | Supported database engines: mysql or postgresql |
| externalDatabase.user | string | `"nextcloud"` | Database user |

### Imaginary

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imaginary.enabled | bool | `false` | Start Imaginary |
| imaginary.image.pullPolicy | string | `"IfNotPresent"` | Imaginary image pull policy |
| imaginary.image.pullSecrets | list | `[]` | Imaginary image pull secrets |
| imaginary.image.registry | string | `"docker.io"` | Imaginary image registry |
| imaginary.image.repository | string | `"h2non/imaginary"` | Imaginary image name |
| imaginary.image.tag | string | `"1.2.4"` | Imaginary image tag |
| imaginary.livenessProbe.enabled | bool | `true` | active liveness probes |
| imaginary.livenessProbe.failureThreshold | int | `3` | liveness probe: threshold for failure |
| imaginary.livenessProbe.periodSeconds | int | `10` | liveness probe: period seconds |
| imaginary.livenessProbe.successThreshold | int | `1` | liveness probe: threshold for success |
| imaginary.livenessProbe.timeoutSeconds | int | `1` | liveness probe: timeout |
| imaginary.podAnnotations | object | `{}` | Additional annotations for imaginary |
| imaginary.podLabels | object | `{}` | Additional labels for imaginary |
| imaginary.podSecurityContext | object | `{}` | Optional security context for the Imaginary pod (applies to all containers in the pod) runAsNonRoot: true seccompProfile:   type: RuntimeDefault |
| imaginary.readinessProbe.enabled | bool | `true` | active readiness probes |
| imaginary.readinessProbe.failureThreshold | int | `3` | readiness probe: threshold for failure |
| imaginary.readinessProbe.periodSeconds | int | `10` | readiness probe: period seconds |
| imaginary.readinessProbe.successThreshold | int | `1` | readiness probe: threshold for success |
| imaginary.readinessProbe.timeoutSeconds | int | `1` | readinees probe: timeout |
| imaginary.replicaCount | int | `1` | Number of imaginary pod replicas to deploy |
| imaginary.resources | object | `{}` | imaginary resources |
| imaginary.securityContext | object | `{"runAsNonRoot":true,"runAsUser":1000}` | Optional security context for the Imaginary container allowPrivilegeEscalation: false capabilities:   drop:     - ALL |
| imaginary.service.annotations | object | `{}` | Additional annotations for service imaginary |
| imaginary.service.labels | object | `{}` | Additional labels for service imaginary |
| imaginary.service.loadBalancerIP | string | `nil` | Imaginary: LoadBalancerIp for service type LoadBalancer |
| imaginary.service.nodePort | string | `nil` | Imaginary: NodePort for service type NodePort |
| imaginary.service.type | string | `"ClusterIP"` | Imaginary: Kubernetes Service type |

### Ingress

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.annotations | object | `{}` | Annotations |
| ingress.className | string | `nil` | className |
| ingress.enabled | bool | `false` |  |
| ingress.labels | object | `{}` |  |
| ingress.path | string | `"/"` |  |
| ingress.pathType | string | `"Prefix"` |  |
| ingress.tls | string | `nil` | TLS   - secretName: nextcloud-tls     hosts:       - nextcloud.kube.home |

### Database - Internal

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| internalDatabase.enabled | bool | `true` |  |
| internalDatabase.name | string | `"nextcloud"` |  |

### Database - MariaDB

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| mariadb.architecture | string | `"standalone"` |  |
| mariadb.auth.database | string | `"nextcloud"` |  |
| mariadb.auth.existingSecret | string | `""` | Use existing secret (auth.rootPassword, auth.password, and auth.replicationPassword will be ignored). secret must contain the keys mariadb-root-password, mariadb-replication-password and mariadb-password |
| mariadb.auth.password | string | `"changeme"` |  |
| mariadb.auth.username | string | `"nextcloud"` |  |
| mariadb.enabled | bool | `false` | Whether to deploy a mariadb server from the bitnami mariab db helm chart to satisfy the applications database requirements. if you want to deploy this bitnami mariadb, set this and externalDatabase to true To use an ALREADY DEPLOYED mariadb database, set this to false and configure the externalDatabase parameters |
| mariadb.global.defaultStorageClass | string | `""` | overwrites the primary.persistence.storageClass value see: https://github.com/bitnami/charts/tree/main/bitnami/mariadb#global-parameters |
| mariadb.primary.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| mariadb.primary.persistence.enabled | bool | `false` |  |
| mariadb.primary.persistence.existingClaim | string | `""` | Use an existing Persistent Volume Claim (must be created ahead of time) |
| mariadb.primary.persistence.size | string | `"8Gi"` |  |
| mariadb.primary.persistence.storageClass | string | `""` |  |
| nextcloud.mariaDbInitContainer.resources | object | `{}` |  |
| nextcloud.mariaDbInitContainer.securityContext | object | `{}` | Set mariadb initContainer securityContext parameters. For example, you may need to define runAsNonRoot directive |

### Metrics

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.affinity | object | `{}` | Metrics exporter pod affinity |
| metrics.enabled | bool | `false` | Setup nextcloud-exporter |
| metrics.https | bool | `false` | The metrics exporter needs to know how you serve Nextcloud either http or https |
| metrics.image.pullPolicy | string | `"IfNotPresent"` | pull policy |
| metrics.image.pullSecrets | string | `nil` | pull secret |
| metrics.image.repository | string | `"xperimental/nextcloud-exporter"` | image repository |
| metrics.image.tag | string | `"0.6.2"` | image tag |
| metrics.info | object | `{"apps":false}` | Info |
| metrics.nodeSelector | object | `{}` | Metrics exporter pod nodeSelector |
| metrics.podAnnotations | object | `{}` | Metrics exporter pod Annotation |
| metrics.podLabels | object | `{}` | Metrics exporter pod Labels |
| metrics.podSecurityContext | object | `{}` | security context for the metrics POD runAsNonRoot: true seccompProfile:   type: RuntimeDefault |
| metrics.replicaCount | int | `1` | relica count of nextcloud-exporter |
| metrics.resources | object | `{}` | Metrics exporter resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources/ |
| metrics.securityContext | object | `{"runAsNonRoot":true,"runAsUser":1000}` | security context for the metrics CONTAINER in the pod allowPrivilegeEscalation: false capabilities:   drop:     - ALL |
| metrics.server | string | `""` | Optional: becomes NEXTCLOUD_SERVER env var in the nextcloud-exporter container. Without it, we will use the full name of the nextcloud service |
| metrics.service.annotations | object | `{"prometheus.io/port":"9205","prometheus.io/scrape":"true"}` | Annotations |
| metrics.service.labels | object | `{}` | Label on Service |
| metrics.service.loadBalancerIP | string | `nil` | Use serviceLoadBalancerIP to request a specific static IP, otherwise leave blank |
| metrics.service.type | string | `"ClusterIP"` | Service Type |
| metrics.serviceMonitor.enabled | bool | `false` | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator |
| metrics.serviceMonitor.interval | string | `"30s"` | Interval at which metrics should be scraped ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#endpoint |
| metrics.serviceMonitor.jobLabel | string | `""` | The name of the label on the target service to use as the job name in prometheus. |
| metrics.serviceMonitor.labels | object | `{}` | Extra labels for the ServiceMonitor |
| metrics.serviceMonitor.namespace | string | `""` | Namespace in which Prometheus is running |
| metrics.serviceMonitor.namespaceSelector | string | `nil` | The selector of the namespace where the target service is located (defaults to the release namespace) |
| metrics.serviceMonitor.scrapeTimeout | string | `""` | Specify the timeout after which the scrape is ended ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#endpoint |
| metrics.timeout | string | `"5s"` | Timeout |
| metrics.tlsSkipVerify | bool | `false` | if set to true, exporter skips certificate verification of Nextcloud server. |
| metrics.token | string | `""` | Use API token if set, otherwise fall back to password authentication https://github.com/xperimental/nextcloud-exporter#token-authentication Currently you still need to set the token manually in your nextcloud install |
| metrics.tolerations | list | `[]` | Metrics exporter pod tolerations |

### Primary ObjectStore - S3

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nextcloud.objectStore.s3.accessKey | string | `""` | ignored if nextcloud.objectstore.s3.existingSecret is not empty string |
| nextcloud.objectStore.s3.autoCreate | bool | `false` | autocreate the bucket |
| nextcloud.objectStore.s3.bucket | string | `""` | required if using s3, the name of the bucket you'd like to use |
| nextcloud.objectStore.s3.enabled | bool | `false` | Enable S3 https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/primary_storage.html#simple-storage-service-s3 |
| nextcloud.objectStore.s3.existingSecret | string | `""` | use an existingSecret for S3 credentials. If set, we ignore the following under nextcloud.objectStore.s3 endpoint, accessKey, secretKey |
| nextcloud.objectStore.s3.host | string | `""` | s3 endpoint to use; only required if you're not using AWS |
| nextcloud.objectStore.s3.legacyAuth | bool | `false` | use legacy auth method |
| nextcloud.objectStore.s3.port | string | `"443"` | default port that can be changed based on your object store, e.g. for minio, you can use 9000 |
| nextcloud.objectStore.s3.prefix | string | `""` | object prefix in bucket |
| nextcloud.objectStore.s3.region | string | `"eu-west-1"` | this is the default in the nextcloud docs |
| nextcloud.objectStore.s3.secretKey | string | `""` | ignored if nextcloud.objectstore.s3.existingSecret is not empty string |
| nextcloud.objectStore.s3.secretKeys.accessKey | string | `""` | key in nextcloud.objectStore.s3.existingSecret to use for s3 accessKeyID |
| nextcloud.objectStore.s3.secretKeys.bucket | string | `""` | key in nextcloud.objectStore.s3.existingSecret to use for the s3 bucket |
| nextcloud.objectStore.s3.secretKeys.host | string | `""` | key in nextcloud.objectStore.s3.existingSecret to use for s3 endpoint |
| nextcloud.objectStore.s3.secretKeys.secretKey | string | `""` | key in nextcloud.objectStore.s3.existingSecret to use for s3 secretAccessKey |
| nextcloud.objectStore.s3.secretKeys.sse_c_key | string | `""` | key in nextcloud.objectStore.s3.existingSecret to use for the s3 sse_c_key |
| nextcloud.objectStore.s3.sse_c_key | string | `""` | server side encryption key. learn more: https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/primary_storage.html#s3-sse-c-encryption-support |
| nextcloud.objectStore.s3.ssl | bool | `true` | use TLS/SSL for S3 connections |
| nextcloud.objectStore.s3.storageClass | string | `"STANDARD"` | optonal parameter: you probably want to keep this as default |
| nextcloud.objectStore.s3.usePathStyle | bool | `false` | set to true if you are not using DNS for your buckets. |

### Primary ObjectStore - Swift

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nextcloud.objectStore.swift.autoCreate | bool | `false` | autocreate container |
| nextcloud.objectStore.swift.container | string | `""` | the container to store the data in |
| nextcloud.objectStore.swift.enabled | bool | `false` | Enabled options related to using Swift as a primary object storage https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/primary_storage.html#openstack-swift |
| nextcloud.objectStore.swift.project.domain | string | `"Default"` | swift project info |
| nextcloud.objectStore.swift.project.name | string | `""` | swift project info |
| nextcloud.objectStore.swift.region | string | `""` |  |
| nextcloud.objectStore.swift.service | string | `"swift"` | optional on some swift implementations |
| nextcloud.objectStore.swift.url | string | `""` | The Identity / Keystone endpoint |
| nextcloud.objectStore.swift.user.domain | string | `"Default"` | swift user info |
| nextcloud.objectStore.swift.user.name | string | `""` | swift user info |
| nextcloud.objectStore.swift.user.password | string | `""` | swift user info |

### Database - PostgreSQL

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nextcloud.postgreSqlInitContainer.resources | object | `{}` |  |
| nextcloud.postgreSqlInitContainer.securityContext | object | `{}` | Set postgresql initContainer securityContext parameters. For example, you may need to define runAsNonRoot directive |
| postgresql.enabled | bool | `false` |  |
| postgresql.global.postgresql.auth.database | string | `"nextcloud"` |  |
| postgresql.global.postgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials. auth.postgresPassword, auth.password, and auth.replicationPassword will be ignored and picked up from this secret. secret might also contains the key ldap-password if LDAP is enabled. ldap.bind_password will be ignored and picked from this secret in this case. |
| postgresql.global.postgresql.auth.password | string | `"changeme"` |  |
| postgresql.global.postgresql.auth.secretKeys.adminPasswordKey | string | `""` | Names of keys in existing secret to use for PostgreSQL credentials |
| postgresql.global.postgresql.auth.secretKeys.replicationPasswordKey | string | `""` | Names of keys in existing secret to use for PostgreSQL credentials |
| postgresql.global.postgresql.auth.secretKeys.userPasswordKey | string | `""` | Names of keys in existing secret to use for PostgreSQL credentials |
| postgresql.global.postgresql.auth.username | string | `"nextcloud"` |  |
| postgresql.primary.persistence.enabled | bool | `false` |  |
| postgresql.primary.persistence.existingClaim | string | `""` | Use an existing Persistent Volume Claim (must be created ahead of time) |
| postgresql.primary.persistence.storageClass | string | `""` |  |

### nginx

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nginx.config.custom | string | `nil` |      worker_processes  1;.. |
| nginx.config.default | bool | `true` | This generates the default nginx config as per the nextcloud documentation |
| nginx.config.headers | object | `{"Referrer-Policy":"no-referrer","Strict-Transport-Security":"","X-Content-Type-Options":"nosniff","X-Download-Options":"noopen","X-Frame-Options":"SAMEORIGIN","X-Permitted-Cross-Domain-Policies":"none","X-Robots-Tag":"noindex, nofollow","X-XSS-Protection":"1; mode=block"}` | Header set on http requerst |
| nginx.config.headers.Strict-Transport-Security | string | `""` | HSTS settings WARNING: Only add the preload option once you read about the consequences in https://hstspreload.org/. This option will add the domain to a hardcoded list that is shipped in all major browsers and getting removed from this list could take several months. Example: "Strict-Transport-Security": "max-age=15768000; includeSubDomains; preload;" |
| nginx.containerPort | int | `80` |  |
| nginx.enabled | bool | `false` | You need to set an fpm version of the image for nextcloud if you want to use nginx!i |
| nginx.extraEnv | list | `[]` | Extra environment variables |
| nginx.image.pullPolicy | string | `"IfNotPresent"` |  |
| nginx.image.repository | string | `"nginx"` |  |
| nginx.image.tag | string | `"alpine"` |  |
| nginx.ipFamilies | list | `["IPv4"]` | This configures nginx to listen on either IPv4, IPv6 or both |
| nginx.resources | object | `{}` |  |
| nginx.securityContext | object | `{}` | Set nginx container securityContext parameters. For example, you may need to define runAsNonRoot directive the nginx alpine container default user is 82   runAsUser: 82   runAsGroup: 33   runAsNonRoot: true   readOnlyRootFilesystem: true |

### redis

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| redis.auth.enabled | bool | `true` |  |
| redis.auth.existingSecret | string | `""` | name of an existing secret with Redis® credentials (instead of auth.password), must be created ahead of time |
| redis.auth.existingSecretPasswordKey | string | `""` | Password key to be retrieved from existing secret |
| redis.auth.password | string | `"changeme"` |  |
| redis.enabled | bool | `false` |  |
| redis.global.storageClass | string | `""` |  |
| redis.master.persistence.enabled | bool | `true` |  |
| redis.replica.persistence.enabled | bool | `true` |  |

### Deprecated

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| securityContext | object | `{}` | for nextcloud pod @deprecated Use `nextcloud.podSecurityContext` instead |

### Other Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| cronjob.enabled | bool | `false` |  |
| cronjob.lifecycle | object | `{}` |  |
| cronjob.resources | object | `{}` |  |
| cronjob.securityContext | object | `{}` |  |
| deploymentAnnotations | object | `{}` |  |
| deploymentLabels | object | `{}` |  |
| dnsConfig | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| hpa.cputhreshold | int | `60` |  |
| hpa.enabled | bool | `false` |  |
| hpa.maxPods | int | `10` |  |
| hpa.minPods | int | `1` |  |
| image.flavor | string | `"apache"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"nextcloud"` |  |
| image.tag | string | `nil` |  |
| imaginary.nodeSelector | object | `{}` | Imaginary pod nodeSelector |
| imaginary.tolerations | list | `[]` | Imaginary pod tolerations |
| lifecycle | object | `{}` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.initialDelaySeconds | int | `10` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| nameOverride | string | `""` |  |
| nextcloud.configs | object | `{}` |  |
| nextcloud.containerPort | int | `80` |  |
| nextcloud.datadir | string | `"/var/www/html/data"` |  |
| nextcloud.defaultConfigs.".htaccess" | bool | `true` |  |
| nextcloud.defaultConfigs."apache-pretty-urls.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."apcu.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."apps.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."autoconfig.php" | bool | `true` |  |
| nextcloud.defaultConfigs."imaginary.config.php" | bool | `false` | imaginary support config |
| nextcloud.defaultConfigs."redis.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."reverse-proxy.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."s3.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."smtp.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."swift.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."upgrade-disable-web.config.php" | bool | `true` |  |
| nextcloud.existingSecret.enabled | bool | `false` |  |
| nextcloud.existingSecret.passwordKey | string | `"nextcloud-password"` |  |
| nextcloud.existingSecret.smtpHostKey | string | `"smtp-host"` |  |
| nextcloud.existingSecret.smtpPasswordKey | string | `"smtp-password"` |  |
| nextcloud.existingSecret.smtpUsernameKey | string | `"smtp-username"` |  |
| nextcloud.existingSecret.tokenKey | string | `""` |  |
| nextcloud.existingSecret.usernameKey | string | `"nextcloud-username"` |  |
| nextcloud.extraEnv | string | `nil` |  |
| nextcloud.extraInitContainers | list | `[]` |  |
| nextcloud.extraSidecarContainers | list | `[]` |  |
| nextcloud.extraVolumeMounts | string | `nil` |  |
| nextcloud.extraVolumes | string | `nil` |  |
| nextcloud.hooks.before-starting | string | `nil` |  |
| nextcloud.hooks.post-installation | string | `nil` |  |
| nextcloud.hooks.post-upgrade | string | `nil` |  |
| nextcloud.hooks.pre-installation | string | `nil` |  |
| nextcloud.hooks.pre-upgrade | string | `nil` |  |
| nextcloud.host | string | `"nextcloud.kube.home"` |  |
| nextcloud.mail.domain | string | `"domain.com"` |  |
| nextcloud.mail.enabled | bool | `false` |  |
| nextcloud.mail.fromAddress | string | `"user"` |  |
| nextcloud.mail.smtp.authtype | string | `"LOGIN"` |  |
| nextcloud.mail.smtp.host | string | `"domain.com"` |  |
| nextcloud.mail.smtp.name | string | `"user"` |  |
| nextcloud.mail.smtp.password | string | `"pass"` |  |
| nextcloud.mail.smtp.port | int | `465` |  |
| nextcloud.mail.smtp.secure | string | `"ssl"` |  |
| nextcloud.password | string | `"changeme"` |  |
| nextcloud.persistence.subPath | string | `nil` |  |
| nextcloud.phpConfigs | object | `{}` |  |
| nextcloud.podSecurityContext | object | `{}` |  |
| nextcloud.securityContext | object | `{}` |  |
| nextcloud.strategy.type | string | `"Recreate"` |  |
| nextcloud.trustedDomains | list | `[]` |  |
| nextcloud.update | int | `0` |  |
| nextcloud.username | string | `"admin"` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `false` |  |
| persistence.nextcloudData.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.nextcloudData.annotations | object | `{}` |  |
| persistence.nextcloudData.enabled | bool | `false` |  |
| persistence.nextcloudData.size | string | `"8Gi"` |  |
| persistence.nextcloudData.subPath | string | `nil` |  |
| persistence.size | string | `"8Gi"` |  |
| phpClientHttpsFix.enabled | bool | `false` |  |
| phpClientHttpsFix.protocol | string | `"https"` |  |
| podAnnotations | object | `{}` |  |
| rbac.enabled | bool | `false` |  |
| rbac.serviceaccount.annotations | object | `{}` |  |
| rbac.serviceaccount.create | bool | `true` |  |
| rbac.serviceaccount.name | string | `"nextcloud-serviceaccount"` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.loadBalancerIP | string | `""` |  |
| service.nodePort | string | `nil` |  |
| service.port | int | `8080` |  |
| service.type | string | `"ClusterIP"` |  |
| startupProbe.enabled | bool | `false` |  |
| startupProbe.failureThreshold | int | `30` |  |
| startupProbe.initialDelaySeconds | int | `30` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.timeoutSeconds | int | `5` |  |
| tolerations | list | `[]` |  |

