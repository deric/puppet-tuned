# puppet-tuned

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
