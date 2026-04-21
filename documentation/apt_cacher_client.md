# apt_cacher_client

Configures APT clients to use an apt-cacher-ng proxy.

## Actions

| Action    | Description                                                                                                                |
|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `:create` | Creates `/etc/apt/apt.conf.d/01proxy` when a server is provided and refreshes APT metadata if the proxy changes (default). |
| `:delete` | Removes the proxy configuration file.                                                                                      |

## Properties

| Property        | Type | Default | Description                                                         |
|-----------------|------|---------|---------------------------------------------------------------------|
| `cacher_server` | Hash | `{}`    | Hash with `host`, `port`, `proxy_ssl`, and optional `cache_bypass`. |

## Examples

```ruby
apt_cacher_client 'default' do
  cacher_server(
    host: 'localhost',
    port: 9876,
    proxy_ssl: true,
    cache_bypass: {
      'download.oracle.com' => 'https',
      'nginx.org' => 'https',
    }
  )
end
```
