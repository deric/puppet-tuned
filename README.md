# puppet-tuned

[![Tests](https://github.com/deric/puppet-tuned/actions/workflows/test.yml/badge.svg)](https://github.com/deric/puppet-tuned/actions/workflows/test.yml)

A module to manage tuneD service and its configuration.

## Usage

Apply defaults, start service use auto-detected profile:

```puppet
include tuned
```

Global configuration (typically stored in `/etc/tuned/tuned-main.conf`)

```yaml
tuned::main:
  update_interval: 15
  sleep_interval: 2
```
Switch to a predefined profile:

```yaml
tuned::profile: balanced
```

see `tuned-adm list` for available options.

## Custom profiles

Create custom profiles, first level key is the profile name, in this case `custom`.
```yaml
tuned::profiles:
  custom:
    main:
      include: balanced
    sysctl:
      net.ipv4.tcp_fastopen: 3
```
This would generate `/etc/tuned/custom/tuned.conf` file with corresponding configuration.

Each section correspods to a plugin name. See `tuned-adm list plugins` for available plugins.
