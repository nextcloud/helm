#!/bin/sh
/var/www/html/occ app:enable notify_push
/var/www/html/occ config:app:set notify_push base_endpoint --value="http{{ if .Values.ingress.tls }}s{{ end }}://{{ .Values.nextcloud.host }}{{ .Values.notifyPush.ingress.path }}"
{{/*
The command "setup" runs a check, which need a running nextcloud (but we try to configurate it during startup).
So that command always failure and we stuck in bootloop.
/var/www/html/occ notify_push:setup "http{{ if .Values.ingress.tls }}s{{ end }}://{{ .Values.nextcloud.host }}{{ .Values.notifyPush.ingress.path }}"
*/}}
