{{/*
Expand the name of the chart.
*/}}
{{- define "nextcloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nextcloud.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified redis app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nextcloud.redis.fullname" -}}
{{- printf "%s-redis" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nextcloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create image name that is used in the deployment
*/}}
{{- define "nextcloud.image" -}}
{{- if .Values.image.tag -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- else -}}
{{- printf "%s:%s-%s" .Values.image.repository .Chart.AppVersion (default "apache" .Values.image.flavor) -}}
{{- end -}}
{{- end -}}


{{- define "nextcloud.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end }}
{{- end -}}


{{/*
Create environment variables used to configure the nextcloud container as well as the cron sidecar container.
*/}}
{{- define "nextcloud.env" -}}
{{- if .Values.phpClientHttpsFix.enabled }}
- name: OVERWRITEPROTOCOL
  value: {{ .Values.phpClientHttpsFix.protocol | quote }}
{{- end }}
{{- if .Values.internalDatabase.enabled }}
- name: SQLITE_DATABASE
  value: {{ .Values.internalDatabase.name | quote }}
{{- else if .Values.mariadb.enabled }}
- name: MYSQL_HOST
  value: {{ template "mariadb.primary.fullname" .Subcharts.mariadb }}
- name: MYSQL_DATABASE
  value: {{ .Values.mariadb.auth.database | quote }}
- name: MYSQL_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.usernameKey }}
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.passwordKey }}
{{- else if .Values.postgresql.enabled }}
- name: POSTGRES_HOST
  value: {{ template "postgresql.v1.primary.fullname" .Subcharts.postgresql }}
- name: POSTGRES_DB
  {{- if .Values.postgresql.auth.database }}
  value: {{ .Values.postgresql.auth.database | quote }}
  {{ else }}
  value: {{ .Values.postgresql.global.postgresql.auth.database | quote }}
  {{- end }}
- name: POSTGRES_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.usernameKey }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.passwordKey }}
{{- else }}
  {{- if eq .Values.externalDatabase.type "postgresql" }}
- name: POSTGRES_HOST
  {{- if .Values.externalDatabase.existingSecret.hostKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.hostKey }}
  {{- else }}
  value: {{ .Values.externalDatabase.host | quote }}
  {{- end }}
- name: POSTGRES_DB
  {{- if .Values.externalDatabase.existingSecret.databaseKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.databaseKey }}
  {{- else }}
  value: {{ .Values.externalDatabase.database | quote }}
  {{- end }}
- name: POSTGRES_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.usernameKey }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.passwordKey }}
  {{- else }}
- name: MYSQL_HOST
  {{- if .Values.externalDatabase.existingSecret.hostKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.hostKey }}
  {{- else }}
  value: {{ .Values.externalDatabase.host | quote }}
  {{- end }}
- name: MYSQL_DATABASE
  {{- if .Values.externalDatabase.existingSecret.databaseKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.databaseKey }}
  {{- else }}
  value: {{ .Values.externalDatabase.database | quote }}
  {{- end }}
- name: MYSQL_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.usernameKey }}
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-db" .Release.Name) }}
      key: {{ .Values.externalDatabase.existingSecret.passwordKey }}
  {{- end }}
{{- end }}
- name: NEXTCLOUD_ADMIN_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.nextcloud.existingSecret.secretName | default (include "nextcloud.fullname" .) }}
      key: {{ .Values.nextcloud.existingSecret.usernameKey }}
- name: NEXTCLOUD_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.nextcloud.existingSecret.secretName | default (include "nextcloud.fullname" .) }}
      key: {{ .Values.nextcloud.existingSecret.passwordKey }}
- name: NEXTCLOUD_TRUSTED_DOMAINS
  value: {{ .Values.nextcloud.host }}
{{- if ne (int .Values.nextcloud.update) 0 }}
- name: NEXTCLOUD_UPDATE
  value: {{ .Values.nextcloud.update | quote }}
{{- end }}
- name: NEXTCLOUD_DATA_DIR
  value: {{ .Values.nextcloud.datadir | quote }}
{{- if .Values.nextcloud.mail.enabled }}
- name: MAIL_FROM_ADDRESS
  value: {{ .Values.nextcloud.mail.fromAddress | quote }}
- name: MAIL_DOMAIN
  value: {{ .Values.nextcloud.mail.domain | quote }}
- name: SMTP_SECURE
  value: {{ .Values.nextcloud.mail.smtp.secure | quote }}
- name: SMTP_PORT
  value: {{ .Values.nextcloud.mail.smtp.port | quote }}
- name: SMTP_AUTHTYPE
  value: {{ .Values.nextcloud.mail.smtp.authtype | quote }}
- name: SMTP_HOST
  valueFrom:
    secretKeyRef:
      name: {{ .Values.nextcloud.existingSecret.secretName | default (include "nextcloud.fullname" .) }}
      key: {{ .Values.nextcloud.existingSecret.smtpHostKey }}
- name: SMTP_NAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.nextcloud.existingSecret.secretName | default (include "nextcloud.fullname" .) }}
      key: {{ .Values.nextcloud.existingSecret.smtpUsernameKey }}
- name: SMTP_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.nextcloud.existingSecret.secretName | default (include "nextcloud.fullname" .) }}
      key: {{ .Values.nextcloud.existingSecret.smtpPasswordKey }}
{{- end }}
{{- if .Values.redis.enabled }}
- name: REDIS_HOST
  value: {{ template "nextcloud.redis.fullname" . }}-master
- name: REDIS_HOST_PORT
  value: {{ .Values.redis.master.service.ports.redis | quote }}
{{- if .Values.redis.auth.enabled }}
{{- if and .Values.redis.auth.existingSecret .Values.redis.auth.existingSecretPasswordKey }}
- name: REDIS_HOST_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.redis.auth.existingSecret }}
      key: {{ .Values.redis.auth.existingSecretPasswordKey }}
{{- else }}
- name: REDIS_HOST_PASSWORD
  value: {{ .Values.redis.auth.password }}
{{- end }}
{{- end }}
{{- end }}
{{- if .Values.nextcloud.extraEnv }}
{{ toYaml .Values.nextcloud.extraEnv }}
{{- end }}
{{- end -}}


{{/*
Create volume mounts for the nextcloud container as well as the cron sidecar container.
*/}}
{{- define "nextcloud.volumeMounts" -}}
- name: nextcloud-main
  mountPath: /var/www/
  subPath: {{ ternary "root" (printf "%s/root" .Values.nextcloud.persistence.subPath) (empty .Values.nextcloud.persistence.subPath) }}
- name: nextcloud-main
  mountPath: /var/www/html
  subPath: {{ ternary "html" (printf "%s/html" .Values.nextcloud.persistence.subPath) (empty .Values.nextcloud.persistence.subPath) }}
{{- if and .Values.persistence.nextcloudData.enabled .Values.persistence.enabled }}
- name: nextcloud-data
  mountPath: {{ .Values.nextcloud.datadir }}
  subPath: {{ ternary "data" (printf "%s/data" .Values.persistence.nextcloudData.subPath) (empty .Values.persistence.nextcloudData.subPath) }}
{{- else }}
- name: nextcloud-main
  mountPath: {{ .Values.nextcloud.datadir }}
  subPath: {{ ternary "data" (printf "%s/data" .Values.persistence.subPath) (empty .Values.persistence.subPath) }}
{{- end }}
- name: nextcloud-main
  mountPath: /var/www/html/config
  subPath: {{ ternary "config" (printf "%s/config" .Values.nextcloud.persistence.subPath) (empty .Values.nextcloud.persistence.subPath) }}
- name: nextcloud-main
  mountPath: /var/www/html/custom_apps
  subPath: {{ ternary "custom_apps" (printf "%s/custom_apps" .Values.nextcloud.persistence.subPath) (empty .Values.nextcloud.persistence.subPath) }}
- name: nextcloud-main
  mountPath: /var/www/tmp
  subPath: {{ ternary "tmp" (printf "%s/tmp" .Values.nextcloud.persistence.subPath) (empty .Values.nextcloud.persistence.subPath) }}
- name: nextcloud-main
  mountPath: /var/www/html/themes
  subPath: {{ ternary "themes" (printf "%s/themes" .Values.nextcloud.persistence.subPath) (empty .Values.nextcloud.persistence.subPath) }}
{{- range $key, $value := .Values.nextcloud.configs }}
- name: nextcloud-config
  mountPath: /var/www/html/config/{{ $key }}
  subPath: {{ $key }}
{{- end }}
{{- if .Values.nextcloud.configs }}
{{- range $key, $value := .Values.nextcloud.defaultConfigs }}
{{- if $value }}
- name: nextcloud-config
  mountPath: /var/www/html/config/{{ $key }}
  subPath: {{ $key }}
{{- end }}
{{- end }}
{{- end }}
{{- if .Values.nextcloud.extraVolumeMounts }}
{{ toYaml .Values.nextcloud.extraVolumeMounts }}
{{- end }}
{{- $nginxEnabled := .Values.nginx.enabled -}}
{{- range $key, $value := .Values.nextcloud.phpConfigs }}
- name: nextcloud-phpconfig
  mountPath: {{ $nginxEnabled | ternary (printf "/usr/local/etc/php-fpm.d/%s" $key | quote) (printf "/usr/local/etc/php/conf.d/%s" $key | quote) }}
  subPath: {{ $key }}
{{- end }}
{{- end -}}
