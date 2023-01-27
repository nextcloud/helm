{{/* vim: set filetype=mustache: */}}
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
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
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
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-%s" .Release.Name "db") }}
      key: {{ .Values.externalDatabase.existingSecret.usernameKey | default "db-username" }}
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-%s" .Release.Name "db") }}
      key: {{ .Values.externalDatabase.existingSecret.passwordKey | default "db-password" }}
{{- else if .Values.postgresql.enabled }}
- name: POSTGRES_HOST
  value: {{ template "postgresql.primary.fullname" .Subcharts.postgresql }}
- name: POSTGRES_DB
  {{- if .Values.postgresql.auth.database }}
  value: {{ .Values.postgresql.auth.database | quote }}
  {{ else }}
  value: {{ .Values.postgresql.global.postgresql.auth.database | quote }}
  {{- end }}
- name: POSTGRES_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-%s" .Release.Name "db") }}
      key: {{ .Values.externalDatabase.existingSecret.usernameKey | default "db-username" }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-%s" .Release.Name "db") }}
      key: {{ .Values.externalDatabase.existingSecret.passwordKey | default "db-password" }}
{{- else }}
  {{- if eq .Values.externalDatabase.type "postgresql" }}
- name: POSTGRES_HOST
  value: {{ .Values.externalDatabase.host | quote }}
- name: POSTGRES_DB
  value: {{ .Values.externalDatabase.database | quote }}
- name: POSTGRES_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-%s" .Release.Name "db") }}
      key: {{ .Values.externalDatabase.existingSecret.usernameKey | default "db-username" }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-%s" .Release.Name "db") }}
      key: {{ .Values.externalDatabase.existingSecret.passwordKey | default "db-password" }}
  {{- else }}
- name: MYSQL_HOST
  value: {{ .Values.externalDatabase.host | quote }}
- name: MYSQL_DATABASE
  value: {{ .Values.externalDatabase.database | quote }}
- name: MYSQL_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-%s" .Release.Name "db") }}
      key: {{ .Values.externalDatabase.existingSecret.usernameKey | default "db-username" }}
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.existingSecret.secretName | default (printf "%s-%s" .Release.Name "db") }}
      key: {{ .Values.externalDatabase.existingSecret.passwordKey | default "db-password" }}
  {{- end }}
{{- end }}
- name: NEXTCLOUD_ADMIN_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.nextcloud.existingSecret.secretName | default (include "nextcloud.fullname" .) }}
      key: {{ .Values.nextcloud.existingSecret.usernameKey | default "nextcloud-username" }}
- name: NEXTCLOUD_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.nextcloud.existingSecret.secretName | default (include "nextcloud.fullname" .) }}
      key: {{ .Values.nextcloud.existingSecret.passwordKey | default "nextcloud-password" }}
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
- name: SMTP_HOST
  value: {{ .Values.nextcloud.mail.smtp.host | quote }}
- name: SMTP_SECURE
  value: {{ .Values.nextcloud.mail.smtp.secure | quote }}
- name: SMTP_PORT
  value: {{ .Values.nextcloud.mail.smtp.port | quote }}
- name: SMTP_AUTHTYPE
  value: {{ .Values.nextcloud.mail.smtp.authtype | quote }}
- name: SMTP_NAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.nextcloud.existingSecret.secretName | default (include "nextcloud.fullname" .) }}
      key: {{ .Values.nextcloud.existingSecret.smtpUsernameKey | default "smtp-username" }}
- name: SMTP_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.nextcloud.existingSecret.secretName | default (include "nextcloud.fullname" .) }}
      key: {{ .Values.nextcloud.existingSecret.smtpPasswordKey | default "smtp-password" }}
{{- end }}
{{- if .Values.redis.enabled }}
- name: REDIS_HOST
  value: {{ template "nextcloud.redis.fullname" . }}-master
- name: REDIS_HOST_PORT
  value: {{ .Values.redis.master.service.ports.redis | quote }}
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
  subPath: {{ ternary "root" (printf "%s/%s" .Values.nextcloud.persistence.subPath "root") (empty .Values.nextcloud.persistence.subPath) }}
- name: nextcloud-main
  mountPath: /var/www/html
  subPath: {{ ternary "html" (printf "%s/%s" .Values.nextcloud.persistence.subPath "html") (empty .Values.nextcloud.persistence.subPath) }}
{{- if and .Values.persistence.nextcloudData.enabled .Values.persistence.enabled }}
- name: nextcloud-data
  mountPath: {{ .Values.nextcloud.datadir }}
  subPath: {{ ternary "data" (printf "%s/%s" .Values.persistence.nextcloudData.subPath "data") (empty .Values.persistence.nextcloudData.subPath) }}
{{- else }}
- name: nextcloud-main
  mountPath: {{ .Values.nextcloud.datadir }}
  subPath: {{ ternary "data" (printf "%s/%s" .Values.persistence.subPath "data") (empty .Values.persistence.subPath) }}
{{- end }}
- name: nextcloud-main
  mountPath: /var/www/html/config
  subPath: {{ ternary "config" (printf "%s/%s" .Values.nextcloud.persistence.subPath "config") (empty .Values.nextcloud.persistence.subPath) }}
- name: nextcloud-main
  mountPath: /var/www/html/custom_apps
  subPath: {{ ternary "custom_apps" (printf "%s/%s" .Values.nextcloud.persistence.subPath "custom_apps") (empty .Values.nextcloud.persistence.subPath) }}
- name: nextcloud-main
  mountPath: /var/www/tmp
  subPath: {{ ternary "tmp" (printf "%s/%s" .Values.nextcloud.persistence.subPath "tmp") (empty .Values.nextcloud.persistence.subPath) }}
- name: nextcloud-main
  mountPath: /var/www/html/themes
  subPath: {{ ternary "themes" (printf "%s/%s" .Values.nextcloud.persistence.subPath "themes") (empty .Values.nextcloud.persistence.subPath) }}
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
