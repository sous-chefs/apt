apt Cookbook
============
This cookbook includes recipes to execute apt-get update to ensure the local APT package cache is up to date. There are recipes for managing the apt-cacher-ng caching proxy and proxy clients. It also includes a LWRP for managing APT repositories in /etc/apt/sources.list.d as well as an LWRP for pinning packages via /etc/apt/preferences.d.


Requirements
------------
**Version 2.0.0+ of this cookbook requires Chef 11.0.0 or later**. If your Chef version is earlier than 11.0.0, use version 1.10.0 of this cookbook.

Version 1.8.2 to 1.10.0 of this cookbook requires **Chef 10.16.4** or later.

If your Chef version is earlier than 10.16.4, use version 1.7.0 of this cookbook.

### Platform
Please refer to the [TESTING file](TESTING.md) to see the currently (and passing) tested platforms. The release was tested on:

* Ubuntu 12.04
* Debian 7.2

May work with or without modification on other Debian derivatives.


-------
### default
First, this recipe includes the `rackspace_apt::repos` recipe to enable Rackspace (mirror.rackspace.com) or user-defined repositories. 

Then the recipe installs the `update-notifier-common` package to provide the timestamp file used to only run `apt-get update` if the cache is more than one day old.

This default recipe should appear first in the run list of Debian or Ubuntu nodes to ensure that the package cache is up to date before managing any `package` resources with Chef.

This recipe also sets up a local cache directory for preseeding packages.

**Including the default recipe on a node that does not support apt (such as Windows) results in a noop.**

### repos
This recipes walks the `node['rackspace_apt']['repos']` hash and defines rackspace_apt_repository lightweight resources for each repository defined. As a convenience, you may set the flag `node['rackspace_apt']['switch']['enable_rackspace_mirrors']` to true and mirror.rackspace.com will be enabled for your operating system. If your OS is unsupported, (e.g. an an older Ubuntu like 10.04, any version of RHEL, etc), setting this flag will not configure Rackspace mirrors and you must define any desired repositories yourself. Operating systems currently supported by `enable_rackspace_mirrors` are:

- Ubuntu 12.04 (precise)
- Debian 7.2 (wheezy)

You may of course define repos via a rackspace_apt_repository LWRP, but alternatively you may define repos in the 
`node['rackspace_apt']['repos']`. Define a new repository like so:

```ruby
node['rackspace_apt']['repos'][<URI>][<DIST>] = %w{<COMPONENT1> <COMPONENT2>}
```

This will create a rackspace_apt_repository lightweight resource with the following parameters:

```ruby
rackspace_apt_repository "apt.opscode.com-precise-0.10" do
  uri <URI>
  distribution <DIST>
  components [<COMPONENT1>, <COMPONENT2>]
  deb_src true
  only_if { node['rackspace_apt']['apt_installed'] }
  not_if { "egrep 'apt.opscode.com precise-0.10' /etc/apt/sources.list" } 
  action :add
end
```

To give a concrete example, specifying this:

```ruby 
node['rackspace_apt']['repos']['apt.opscode.com']['precise-0.10'] = %w{main testing}
```

will create a rackspace_apt_repository lightweight resource like this:

```ruby
rackspace_apt_repository "apt.opscode.com-precise-0.10" do
  uri "http://apt.opscode.com/"
  distribution "precise-0.10"
  components ['main', 'testing']
  deb_src true
  only_if { node['rackspace_apt']['apt_installed'] }
  not_if { "egrep 'apt.opscode.com precise-0.10' /etc/apt/sources.list" } 
  action :add
end
```

The `only_if` and `not_if` blocks prevent the repository from being configured if `apt` is not installed or if the repository is already configured
in /etc/apt/sources.list (respectively).

The `repos` recipe is included at the beginning of the default recipe; you should not explicity include it in a run list.

### cacher-client
Configures the node to use the `apt-cacher-ng` server as a client.

#### Bypassing the cache
Occasionally you may come across repositories that do not play nicely when the node is using an `apt-cacher-ng` server. You can configure `cacher-client` to bypass the server and connect directly to the repository with the `cache_bypass` attribute.

To do this, you need to override the `cache_bypass` attribute with an array of repositories, with each array key as the repository URL and value as the protocol to use:

```json
{
    ...,
    'rackspace_apt': {
        ...,
        'config': {
            ...,
            'cacher_client': {
                 ...,
                 'cache_bypass': {
                     URL: PROTOCOL
                 }
             }
        }
    }
}
```

For example, to prevent caching and directly connect to the repository at `download.oracle.com` via http:

```json
{
    ...,
    'rackspace_apt': {
        ...,
        'config': {
            ...,
            'cacher_client': {
                 ...,                 
                 'cache_bypass': {
                     'download.oracle.com': 'http'
                 }
             }
        }
    }
}
```

### cacher-ng
Installs the `apt-cacher-ng` package and service so the system can provide APT caching. You can check the usage report at http://{hostname}:3142/acng-report.html.

If you wish to help the `cacher-ng` recipe seed itself, you must now explicitly include the `cacher-client` recipe in your run list **after** `cacher-ng` or you will block your ability to install any packages (ie. `apt-cacher-ng`).


Attributes
----------
* `['rackspace_apt']['switch']['cacher_server']['cacher_interface']` - interface to connect to the cacher-ng service, no default.
* `['rackspace_apt']['config']['cacher_server']['Port']['value']` - port for the cacher-ng service (either client or server), default is '3142'
* `['rackspace_apt']['config']['cacher_server']['CacheDir']['value']` - directory used by cacher-ng service, default is '/var/cache/apt-cacher-ng'
* `['rackspace_apt']['switch']['cacher_client']['restrict_environment']` - restrict your node to using the `apt-cacher-ng` server in your Environment. Default is `false`
* `['rackspace_apt']['config']['cacher_client']['cacher_ipaddress']` - use a cacher server (or standard proxy server) not available via search. No default (unset).
* `['rackspace_apt']['config']['cacher_client']['cache_bypass']` - array of URLs to bypass the cache. Accepts the URL and protocol to  fetch directly from the remote repository and not attempt to cache
* `['rackspace_apt']['switch']['compiletime']` - force the `cacher-client` recipe to run before other recipes. It forces apt to use the proxy before other recipes run. Useful if your nodes have limited access to public apt repositories. This is overridden if the `cacher-ng` recipe is in your run list. Default is 'false'
* `['rackspace_apt']['switch']['enable_rackspace_mirrors']` - enable mirror.rackspace.com apt repositories for your supported Ubuntu or Debian server. Default is `true`.
* `['rackspace_apt']['switch']['delete_sources_list']` - set to `true` to remove the file /etc/apt/sources.list. Typically you would only want to do this if enabling mirror.rackspace.com or some other major repository via rackspace_apt_repository lightweight resources or node['rackspace_apt]['repos]. Default is `false`.

Libraries
---------
There is an `interface_ipaddress` method that returns the IP address for a particular host and interface, used by the `cacher-client` recipe. To enable it on the server use the `['rackspace_apt']['switch']['cacher_server']['cacher_interface']` attribute.

Resources/Providers
-------------------
### `rackspace_apt_repository`
This LWRP provides an easy way to manage additional APT repositories. Adding a new repository will notify running the `execute[apt-get-update]` resource immediately.

#### Actions
- :add: creates a repository file and builds the repository listing
- :remove: removes the repository file

#### Attribute Parameters
- repo_name: name attribute. The name of the channel to discover
- uri: the base of the Debian distribution
- distribution: this is usually your release's codename...ie something like `karmic`, `lucid` or `maverick`
- components: package groupings..when it doubt use `main`
- arch: constrain package to a particular arch like `i386`, `amd64` or even `armhf` or `powerpc`. Defaults to nil.
- trusted: treat all packages from this repository as authenticated regardless of signature
- deb_src: whether or not to add the repository as a source repo as well - value can be `true` or `false`, default `false`.
- keyserver: the GPG keyserver where the key for the repo should be retrieved
- key: if a `keyserver` is provided, this is assumed to be the fingerprint, otherwise it can be either the URI to the GPG key for the repo, or a cookbook_file.
- key_proxy: if set, pass the specified proxy via `http-proxy=` to GPG.
- cookbook: if key should be a cookbook_file, specify a cookbook where the key is located for files/default. Defaults to nil, so it will use the cookbook where the resource is used.

#### Examples

Add the Zenoss repo:

```ruby
rackspace_apt_repository 'zenoss' do
  uri        'http://dev.zenoss.org/deb'
  components ['main', 'stable']
end
```

Add the Nginx PPA, grabbing the key from keyserver:

```ruby
rackspace_apt_repository 'nginx-php' do
  uri          'http://ppa.launchpad.net/nginx/php5/ubuntu'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'C300EE8C'
end
```

Add the Nginx PPA, grab the key from the keyserver, and add source repo:

```ruby
rackspace_apt_repository 'nginx-php' do
  uri          'http://ppa.launchpad.net/nginx/php5/ubuntu'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'C300EE8C'
  deb_src      true
end
```

Add the Cloudera Repo of CDH4 packages for Ubuntu 12.04 on AMD64:

```ruby
rackspace_apt_repository 'cloudera' do
  uri          'http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh'
  arch         'amd64'
  distribution 'precise-cdh4'
  components   ['contrib']
  key          'http://archive.cloudera.com/debian/archive.key'
end
```

Remove Zenoss repo:

```ruby
rackspace_apt_repository 'zenoss' do
  action :remove
end
```

### `rackspace_apt_preference`
This LWRP provides an easy way to pin packages in /etc/apt/preferences.d. Although apt-pinning is quite helpful from time to time please note that Debian does not encourage its use without thorough consideration.

Further information regarding apt-pinning is available via http://wiki.debian.org/AptPreferences.

#### Actions
- :add: creates a preferences file under /etc/apt/preferences.d
- :remove: Removes the file, therefore unpin the package

#### Attribute Parameters
- package_name: name attribute. The name of the package
- glob: Pin by glob() expression or regexp surrounded by /.
- pin: The package version/repository to pin
- pin_priority: The pinning priority aka "the highest package version wins"

#### Examples
Pin libmysqlclient16 to version 5.1.49-3:

```ruby
rackspace_apt_preference 'libmysqlclient16' do
  pin          'version 5.1.49-3'
  pin_priority '700'
end
```

Unpin libmysqlclient16:

```ruby
rackspace_apt_preference 'libmysqlclient16' do
  action :remove
end
```

Pin all packages from dotdeb.org:

```ruby
rackspace_apt_preference 'dotdeb' do
  glob         '*'
  pin          'origin packages.dotdeb.org'
  pin_priority '700'
end
```


Usage
-----
Put `recipe[rackspace_apt]` first in the run list. If you have other recipes that you want to use to configure how apt behaves, like new sources, notify the execute resource to run, e.g.:

```ruby
template '/etc/apt/sources.list.d/my_apt_sources.list' do
  notifies :run, 'execute[apt-get update]', :immediately
end
```

The above will run during execution phase since it is a normal template resource, and should appear before other package resources that need the sources in the template.

Put `recipe[rackspace_apt::cacher-ng]` in the run_list for a server to provide APT caching and add `recipe[rackspace_apt::cacher-client]` on the rest of the Debian-based nodes to take advantage of the caching server.

If you want to cleanup unused packages, there is also the `apt-get autoclean` and `apt-get autoremove` resources provided for automated cleanup.


License & Authors
-----------------
- Author:: Joshua Timberman (joshua@opscode.com)
- Author:: Matt Ray (matt@opscode.com)
- Author:: Seth Chisamore (schisamo@opscode.com)
- Author:: Kent Shultz (kent.shultz@rackspace.com)

```text
Copyright 2014, Rackspace, US Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
