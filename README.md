# apt Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/apt.svg)](https://supermarket.chef.io/cookbooks/apt)
[![CI State](https://github.com/sous-chefs/apt/workflows/ci/badge.svg)](https://github.com/sous-chefs/apt/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook is resource-first. It provides custom resources for base APT configuration, apt-cacher client and server management, and unattended-upgrades configuration on Debian-family systems. It does not ship recipe entrypoints or attribute-driven configuration.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian 12+
- Ubuntu 22.04+

May work with or without modification on other Debian derivatives.

### Chef

- Chef 15.3+

### Cookbooks

- None

## Usage

Declare `apt_config` early in the run so APT metadata and common configuration are in place before package resources that depend on them.

### Base configuration

```ruby
apt_config 'default'
```

To force the initial update during compile phase, use the common `compile_time` property on the resource:

```ruby
apt_config 'compile-time' do
  periodic_update_min_delay 0
  compile_time_update true
  compile_time true
end
```

### Client-side apt-cacher

```ruby
apt_cacher_client 'default' do
  cacher_server(
    host: 'cache.example.com',
    port: 3142,
    proxy_ssl: true,
    cache_bypass: {
      'download.oracle.com' => 'https',
      'nginx.org' => 'https',
    }
  )
end
```

### Server-side apt-cacher

```ruby
apt_cacher_ng 'default' do
  cacher_dir '/var/cache/apt-cacher-ng'
  cacher_port 3142
  cacher_interface '0.0.0.0'
end
```

### Unattended upgrades

```ruby
apt_unattended_upgrades 'default' do
  enable true
  allowed_origins []
  origins_patterns ['origin=Debian,label=Debian-Security']
  dpkg_options ['--force-confold']
end
```

## Resource Reference

- [`apt_config`](documentation/apt_config.md)
- [`apt_cacher_client`](documentation/apt_cacher_client.md)
- [`apt_cacher_ng`](documentation/apt_cacher_ng.md)
- [`apt_unattended_upgrades`](documentation/apt_unattended_upgrades.md)

## Resources

### apt_preference

The apt_preference resource has been moved into chef-client in Chef 13.3.

See <https://docs.chef.io/resource_apt_preference.html> for usage details

### apt_repository

The apt_repository resource has been moved into chef-client in Chef 12.9.

See <https://docs.chef.io/resource_apt_repository.html> for usage details

### apt_update

The apt_update resource has been moved into chef-client in Chef 12.7.

See <https://docs.chef.io/resource_apt_update.html> for usage details

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
