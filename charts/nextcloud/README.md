# nextcloud

![Version: 6.0.1](https://img.shields.io/badge/Version-6.0.1-informational?style=flat-square) ![AppVersion: 30.0.0](https://img.shields.io/badge/AppVersion-30.0.0-informational?style=flat-square)

A file sharing server that puts the control and security of your own data back into your hands.

**Homepage:** <https://nextcloud.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| skjnldsv | <skjnldsv@protonmail.com> |  |
| chrisingenhaag | <christian.ingenhaag@googlemail.com> |  |
| billimek | <jeff@billimek.com> |  |

## Source Code

* <https://github.com/nextcloud/helm>
* <https://github.com/nextcloud/docker>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | mariadb | 18.2.0 |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 15.5.0 |
| oci://registry-1.docker.io/bitnamicharts | redis | 19.5.0 |

## Values

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
| externalDatabase.database | string | `"nextcloud"` |  |
| externalDatabase.enabled | bool | `false` |  |
| externalDatabase.existingSecret.enabled | bool | `false` |  |
| externalDatabase.existingSecret.passwordKey | string | `"db-password"` |  |
| externalDatabase.existingSecret.usernameKey | string | `"db-username"` |  |
| externalDatabase.host | string | `nil` |  |
| externalDatabase.password | string | `""` |  |
| externalDatabase.type | string | `"mysql"` |  |
| externalDatabase.user | string | `"nextcloud"` |  |
| fullnameOverride | string | `""` |  |
| hpa.cputhreshold | int | `60` |  |
| hpa.enabled | bool | `false` |  |
| hpa.maxPods | int | `10` |  |
| hpa.minPods | int | `1` |  |
| image.flavor | string | `"apache"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"nextcloud"` |  |
| image.tag | string | `nil` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.labels | object | `{}` |  |
| ingress.path | string | `"/"` |  |
| ingress.pathType | string | `"Prefix"` |  |
| internalDatabase.enabled | bool | `true` |  |
| internalDatabase.name | string | `"nextcloud"` |  |
| lifecycle | object | `{}` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.initialDelaySeconds | int | `10` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| mariadb.architecture | string | `"standalone"` |  |
| mariadb.auth.database | string | `"nextcloud"` |  |
| mariadb.auth.existingSecret | string | `""` |  |
| mariadb.auth.password | string | `"changeme"` |  |
| mariadb.auth.username | string | `"nextcloud"` |  |
| mariadb.enabled | bool | `false` |  |
| mariadb.global.defaultStorageClass | string | `""` |  |
| mariadb.primary.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| mariadb.primary.persistence.enabled | bool | `false` |  |
| mariadb.primary.persistence.existingClaim | string | `""` |  |
| mariadb.primary.persistence.size | string | `"8Gi"` |  |
| mariadb.primary.persistence.storageClass | string | `""` |  |
| metrics.affinity | object | `{}` | Metrics exporter pod affinity |
| metrics.enabled | bool | `false` |  |
| metrics.https | bool | `false` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.repository | string | `"xperimental/nextcloud-exporter"` |  |
| metrics.image.tag | string | `"0.6.2"` |  |
| metrics.info.apps | bool | `false` |  |
| metrics.nodeSelector | object | `{}` | Metrics exporter pod nodeSelector |
| metrics.podAnnotations | object | `{}` | Metrics exporter pod Annotation |
| metrics.podLabels | object | `{}` | Metrics exporter pod Labels |
| metrics.podSecurityContext | object | `{}` | security context for the metrics POD |
| metrics.replicaCount | int | `1` |  |
| metrics.resources | object | `{}` |  |
| metrics.securityContext | object | `{"runAsNonRoot":true,"runAsUser":1000}` | security context for the metrics CONTAINER in the pod |
| metrics.server | string | `""` |  |
| metrics.service.annotations."prometheus.io/port" | string | `"9205"` |  |
| metrics.service.annotations."prometheus.io/scrape" | string | `"true"` |  |
| metrics.service.labels | object | `{}` |  |
| metrics.service.loadBalancerIP | string | `nil` |  |
| metrics.service.type | string | `"ClusterIP"` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `"30s"` |  |
| metrics.serviceMonitor.jobLabel | string | `""` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.namespaceSelector | string | `nil` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| metrics.timeout | string | `"5s"` |  |
| metrics.tlsSkipVerify | bool | `false` |  |
| metrics.token | string | `""` |  |
| metrics.tolerations | list | `[]` | Metrics exporter pod tolerations |
| nameOverride | string | `""` |  |
| nextcloud.configs | object | `{}` |  |
| nextcloud.containerPort | int | `80` |  |
| nextcloud.datadir | string | `"/var/www/html/data"` |  |
| nextcloud.defaultConfigs.".htaccess" | bool | `true` |  |
| nextcloud.defaultConfigs."apache-pretty-urls.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."apcu.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."apps.config.php" | bool | `true` |  |
| nextcloud.defaultConfigs."autoconfig.php" | bool | `true` |  |
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
| nextcloud.mariaDbInitContainer.securityContext | object | `{}` |  |
| nextcloud.objectStore.s3.accessKey | string | `""` |  |
| nextcloud.objectStore.s3.autoCreate | bool | `false` |  |
| nextcloud.objectStore.s3.bucket | string | `""` |  |
| nextcloud.objectStore.s3.enabled | bool | `false` |  |
| nextcloud.objectStore.s3.existingSecret | string | `""` |  |
| nextcloud.objectStore.s3.host | string | `""` |  |
| nextcloud.objectStore.s3.legacyAuth | bool | `false` |  |
| nextcloud.objectStore.s3.port | string | `"443"` |  |
| nextcloud.objectStore.s3.prefix | string | `""` |  |
| nextcloud.objectStore.s3.region | string | `"eu-west-1"` |  |
| nextcloud.objectStore.s3.secretKey | string | `""` |  |
| nextcloud.objectStore.s3.secretKeys.accessKey | string | `""` |  |
| nextcloud.objectStore.s3.secretKeys.bucket | string | `""` |  |
| nextcloud.objectStore.s3.secretKeys.host | string | `""` |  |
| nextcloud.objectStore.s3.secretKeys.secretKey | string | `""` |  |
| nextcloud.objectStore.s3.secretKeys.sse_c_key | string | `""` |  |
| nextcloud.objectStore.s3.sse_c_key | string | `""` |  |
| nextcloud.objectStore.s3.ssl | bool | `true` |  |
| nextcloud.objectStore.s3.storageClass | string | `"STANDARD"` |  |
| nextcloud.objectStore.s3.usePathStyle | bool | `false` |  |
| nextcloud.objectStore.swift.autoCreate | bool | `false` |  |
| nextcloud.objectStore.swift.container | string | `""` |  |
| nextcloud.objectStore.swift.enabled | bool | `false` |  |
| nextcloud.objectStore.swift.project.domain | string | `"Default"` |  |
| nextcloud.objectStore.swift.project.name | string | `""` |  |
| nextcloud.objectStore.swift.region | string | `""` |  |
| nextcloud.objectStore.swift.service | string | `"swift"` |  |
| nextcloud.objectStore.swift.url | string | `""` |  |
| nextcloud.objectStore.swift.user.domain | string | `"Default"` |  |
| nextcloud.objectStore.swift.user.name | string | `""` |  |
| nextcloud.objectStore.swift.user.password | string | `""` |  |
| nextcloud.password | string | `"changeme"` |  |
| nextcloud.persistence.subPath | string | `nil` |  |
| nextcloud.phpConfigs | object | `{}` |  |
| nextcloud.podSecurityContext | object | `{}` |  |
| nextcloud.postgreSqlInitContainer.securityContext | object | `{}` |  |
| nextcloud.securityContext | object | `{}` |  |
| nextcloud.strategy.type | string | `"Recreate"` |  |
| nextcloud.trustedDomains | list | `[]` |  |
| nextcloud.update | int | `0` |  |
| nextcloud.username | string | `"admin"` |  |
| nginx.config.custom | string | `nil` |  |
| nginx.config.default | bool | `true` |  |
| nginx.containerPort | int | `80` |  |
| nginx.enabled | bool | `false` |  |
| nginx.extraEnv | list | `[]` |  |
| nginx.image.pullPolicy | string | `"IfNotPresent"` |  |
| nginx.image.repository | string | `"nginx"` |  |
| nginx.image.tag | string | `"alpine"` |  |
| nginx.resources | object | `{}` |  |
| nginx.securityContext | object | `{}` |  |
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
| postgresql.enabled | bool | `false` |  |
| postgresql.global.postgresql.auth.database | string | `"nextcloud"` |  |
| postgresql.global.postgresql.auth.existingSecret | string | `""` |  |
| postgresql.global.postgresql.auth.password | string | `"changeme"` |  |
| postgresql.global.postgresql.auth.secretKeys.adminPasswordKey | string | `""` |  |
| postgresql.global.postgresql.auth.secretKeys.replicationPasswordKey | string | `""` |  |
| postgresql.global.postgresql.auth.secretKeys.userPasswordKey | string | `""` |  |
| postgresql.global.postgresql.auth.username | string | `"nextcloud"` |  |
| postgresql.primary.persistence.enabled | bool | `false` |  |
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
| redis.auth.enabled | bool | `true` |  |
| redis.auth.existingSecret | string | `""` |  |
| redis.auth.existingSecretPasswordKey | string | `""` |  |
| redis.auth.password | string | `"changeme"` |  |
| redis.enabled | bool | `false` |  |
| redis.global.storageClass | string | `""` |  |
| redis.master.persistence.enabled | bool | `true` |  |
| redis.replica.persistence.enabled | bool | `true` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
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

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
