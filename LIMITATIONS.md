# APT Cookbook Limitations

- This cookbook is scoped to Debian-family systems that actually provide `apt-get`; it should not be used on RPM-based platforms.
- The custom resources in this migration target Debian 12, Debian 13, Ubuntu 22.04, and Ubuntu 24.04.
- `apt_cacher_ng` depends on the `apt-cacher-ng` package being available from the configured package repositories.
- Debian 13 (Trixie) is current through August 9, 2028, and Debian package metadata currently publishes both `apt-cacher-ng` and `unattended-upgrades` there.
