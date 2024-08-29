# puppet-tuned

[![Puppet Forge](http://img.shields.io/puppetforge/v/deric/tuned.svg)](https://forge.puppet.com/modules/deric/tuned) [![Tests](https://github.com/deric/puppet-tuned/actions/workflows/test.yml/badge.svg)](https://github.com/deric/puppet-tuned/actions/workflows/test.yml)

A module to manage [tuneD](https://github.com/redhat-performance/tuned) service and its configuration.

## Usage

Apply defaults, start service use auto-detected profile:

```puppet
include tuned
```

Global configuration (typically stored in `/etc/tuned/tuned-main.conf`)

```yaml
tuned::main:
  # Whether to use daemon. Without daemon it just applies tuning. It is
  # not recommended, because many functions don't work without daemon,
  # e.g. there will be no D-Bus, no rollback of settings, no hotplug,
  # no dynamic tuning, ...
  daemon: 1

  # Dynamicaly tune devices, if disabled only static tuning will be used.
  dynamic_tuning: 1

  # How long to sleep before checking for events (in seconds)
  # higher number means lower overhead but longer response time.
  sleep_interval: 1

  # Update interval for dynamic tunings (in seconds).
  # It must be multiply of the sleep_interval.
  update_interval: 10

  # Recommend functionality, if disabled "recommend" command will be not
  # available in CLI, daemon will not parse recommend.conf but will return
  # one hardcoded profile (by default "balanced").
  recommend_command: 1

  # Whether to reapply sysctl from /run/sysctl.d/, /etc/sysctl.d/ and
  # /etc/sysctl.conf.  If enabled, these sysctls will be re-appliead
  # after TuneD sysctls are applied, i.e. TuneD sysctls will not
  # override user-provided system sysctls.
  reapply_sysctl: 1
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


Operators `=>` can be used by passing value starting with `>`

```yaml
tuned::profile: io
tuned::profiles:
  io:
    disk-sd:
      type: disk
      readahead: '>4096'
```

Each section correspods to a plugin name. See `tuned-adm list plugins` for available plugins, e.g.:

```
$ tuned-adm list plugins
rtentsk
systemd
video
vm
scsi_host
disk
script
sysctl
sysfs
eeepc_she
irqbalance
selinux
modules
usb
bootloader
mounts
cpu
audio
service
scheduler
net
```
