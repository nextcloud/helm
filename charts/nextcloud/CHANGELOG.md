# Changelog

This Helm-Chart increase there major version on every breaking change (or major version of Nextcloud itself) inspired by semantic releases.

Here we list all major versions and their breaking changes for migration.


## v7

- move `metrics.serviceMonitor` to `prometheus.serviceMonitor`: It is used for nextcloud-exporter and notify-push
