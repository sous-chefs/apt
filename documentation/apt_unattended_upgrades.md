# apt_unattended_upgrades

Installs and configures unattended-upgrades, including the debconf preseed used during package installation.

## Actions

| Action    | Description                                                                              |
|-----------|------------------------------------------------------------------------------------------|
| `:create` | Stages the preseed, installs unattended-upgrades, and writes its config files (default). |
| `:delete` | Removes unattended-upgrades packages and config files.                                   |

## Properties

| Property                     | Type                 | Default                   | Description                                |
|------------------------------|----------------------|---------------------------|--------------------------------------------|
| `enable`                     | Boolean              | `false`                   | Enables unattended upgrades.               |
| `update_package_lists`       | Boolean              | `true`                    | Enables package list refreshes.            |
| `allowed_origins`            | Array                | platform codename derived | Allowed package origins.                   |
| `origins_patterns`           | Array                | `[]`                      | Additional origin matching patterns.       |
| `package_blacklist`          | Array                | `[]`                      | Packages to exclude.                       |
| `auto_fix_interrupted_dpkg`  | Boolean              | `false`                   | Enables interrupted dpkg repair.           |
| `minimal_steps`              | Boolean              | `false`                   | Uses smaller upgrade chunks.               |
| `install_on_shutdown`        | Boolean              | `false`                   | Defers updates to shutdown.                |
| `mail`                       | String, nil          | `nil`                     | Notification email address.                |
| `sender`                     | String, nil          | `nil`                     | Sender email address.                      |
| `mail_only_on_error`         | Boolean              | `true`                    | Sends mail only on errors.                 |
| `remove_unused_dependencies` | Boolean              | `false`                   | Removes unused dependencies after upgrade. |
| `automatic_reboot`           | Boolean              | `false`                   | Enables automatic reboot after upgrades.   |
| `automatic_reboot_time`      | String               | `'now'`                   | Scheduled reboot time.                     |
| `dl_limit`                   | Integer, String, nil | `nil`                     | Download speed limit.                      |
| `random_sleep`               | Integer, String, nil | `nil`                     | Random sleep duration.                     |
| `syslog_enable`              | Boolean              | `false`                   | Enables syslog logging.                    |
| `syslog_facility`            | String               | `'daemon'`                | Syslog facility name.                      |
| `only_on_ac_power`           | Boolean              | `true`                    | Limits updates to AC power.                |
| `dpkg_options`               | Array                | `[]`                      | Dpkg options written into the config.      |

## Examples

```ruby
apt_unattended_upgrades 'default' do
  enable true
  allowed_origins []
  dpkg_options ['--force-confold']
end
```
