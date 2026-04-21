# apt_cacher_ng

Installs and configures an apt-cacher-ng service instance.

## Actions

| Action    | Description                                                         |
|-----------|---------------------------------------------------------------------|
| `:create` | Installs and starts apt-cacher-ng (default).                        |
| `:delete` | Stops apt-cacher-ng and removes its package, config, and cache dir. |

## Properties

| Property           | Type            | Default                      | Description                            |
|--------------------|-----------------|------------------------------|----------------------------------------|
| `cacher_dir`       | String          | `'/var/cache/apt-cacher-ng'` | Cache directory used by apt-cacher-ng. |
| `cacher_port`      | Integer, String | `3142`                       | TCP port used by apt-cacher-ng.        |
| `cacher_interface` | String, nil     | `nil`                        | Optional bind interface or address.    |

## Examples

```ruby
apt_cacher_ng 'default' do
  cacher_dir '/tmp/apt-cacher'
  cacher_port 9876
  cacher_interface '0.0.0.0'
end
```
