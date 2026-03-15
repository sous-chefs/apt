# APT Cookbook Limitations

- This cookbook is scoped to Debian-family systems that actually provide `apt-get`; it should not be used on RPM-based platforms.
- The custom resources in this migration only target Debian 12+ and Ubuntu 22.04+.
- `apt_cacher_ng` depends on the `apt-cacher-ng` package being available from the configured package repositories.
