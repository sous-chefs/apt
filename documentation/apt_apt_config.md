# apt_apt_config

Configures base APT update behavior and common apt.conf settings.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates the base APT configuration and helper directories (default). |
| `:delete` | Removes the files and packages created by the resource. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `periodic_update_min_delay` | Integer | `86400` | Delay between periodic update runs. |
| `compile_time_update` | Boolean | `false` | Runs an immediate `apt_update` when the resource converges. |
| `force_confask` | Boolean | `false` | Adds `--force-confask` to dpkg options. |
| `force_confdef` | Boolean | `false` | Adds `--force-confdef` to dpkg options. |
| `force_confmiss` | Boolean | `false` | Adds `--force-confmiss` to dpkg options. |
| `force_confnew` | Boolean | `false` | Adds `--force-confnew` to dpkg options. |
| `force_confold` | Boolean | `false` | Adds `--force-confold` to dpkg options. |
| `install_recommends` | Boolean | `true` | Controls `APT::Install-Recommends`. |
| `install_suggests` | Boolean | `false` | Controls `APT::Install-Suggests`. |

## Examples

```ruby
apt_config 'default'
```
