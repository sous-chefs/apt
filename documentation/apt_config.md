# apt_config

Configures base APT update behavior, the local preseeding cache, and common `apt.conf` settings.

## Actions

| Action    | Description                                                          |
|-----------|----------------------------------------------------------------------|
| `:create` | Creates the base APT configuration and helper directories (default). |
| `:delete` | Removes the files and packages created by the resource.              |

## Properties

| Property                    | Type    | Default | Description                                                              |
|-----------------------------|---------|---------|--------------------------------------------------------------------------|
| `periodic_update_min_delay` | Integer | `86400` | Delay between periodic update runs.                                      |
| `compile_time_update`       | Boolean | `false` | Runs an immediate `apt_update` in addition to the periodic `apt_update`. |
| `force_confask`             | Boolean | `false` | Adds `--force-confask` to dpkg options.                                  |
| `force_confdef`             | Boolean | `false` | Adds `--force-confdef` to dpkg options.                                  |
| `force_confmiss`            | Boolean | `false` | Adds `--force-confmiss` to dpkg options.                                 |
| `force_confnew`             | Boolean | `false` | Adds `--force-confnew` to dpkg options.                                  |
| `force_confold`             | Boolean | `false` | Adds `--force-confold` to dpkg options.                                  |
| `install_recommends`        | Boolean | `true`  | Controls `APT::Install-Recommends`.                                      |
| `install_suggests`          | Boolean | `false` | Controls `APT::Install-Suggests`.                                        |

## Examples

```ruby
apt_config 'default'
```

```ruby
apt_config 'compile-time' do
  periodic_update_min_delay 0
  compile_time_update true
  compile_time true
end
```
