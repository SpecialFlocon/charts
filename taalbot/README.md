# taalbot

taalbot is a Discord bot helping Dutch learners, among other things.

## TL;DR;

```console
$ helm install ./helm-charts/taalbot
```

## Introduction

This chart bootstraps a [taalbot](https://github.com/SpecialFlocon/taalbot) deployment
on a [Kubernetes](http://kubernetes.io) cluster using the
[Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+
- A working taalapi deployment
- A Discord bot token, obtained via Discord developer portal after creating an
  app

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release ./helm-charts/taalbot
```

The command deploys taalbot on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the taalbot chart and
their default values.

|              Parameter                 |                                      Description                                       |                   Default                     |
|----------------------------------------|----------------------------------------------------------------------------------------|-----------------------------------------------|
| `imagePullSecrets`                     | Specify image pull secrets                                                             | `[]`                                          |
| `extraLabels`                          | Labels to add to resources                                                             | `{}`                                          |
| `taalbot.image.registry`               | taalbot image registry                                                                 | `docker.io`                                   |
| `taalbot.image.repository`             | taalbot image name                                                                     | `specialflocon/taalbot`                       |
| `taalbot.image.tag`                    | taalbot image tag                                                                      | `.Chart.AppVersion`                           |
| `taalbot.image.pullPolicy`             | Image pull policy                                                                      | `Always`                                      |
| `taalbot.image.args`                   | Container entrypoint arguments                                                         | `[]`                                          |
| `taalbot.resources.limits`             | Container CPU/memory resource limits                                                   | Memory: `64Mi`, CPU: `100m`                   |
| `taalbot.resources.requests`           | Container CPU/memory resource requests                                                 | Memory: `64Mi`, CPU: `100m`                   |
| `taalbot.livenessProbe`                | Container liveness probe                                                               | See `values.yaml`                             |
| `taalbot.readinessProbe`               | Container readiness probe                                                              | See `values.yaml`                             |
| `taalbot.secretName`                   | Name of the secret containing taalbot secret data                                      | `""`                                          |
| `taalbot.application.apiServerURL`     | URL to a running API server                                                            | `""`                                          |
| `taalbot.httpClient.tls.enabled`       | Enable/disable TLS                                                                     | `""`                                          |
| `taalbot.httpClient.tls.secretName`    | Name of the secret containing TLS certificate chain files                              | `""`                                          |
| `taalbot.httpClient.tls.mountPath`     | Mountpoint of the TLS secret within the container                                      | `""`                                          |
| `taalbot.httpClient.tls.caCert`        | Path to a TLS CA certificate file                                                      | `""`                                          |
| `taalbot.httpClient.tls.cert`          | Path to a TLS certificate file                                                         | `""`                                          |
| `taalbot.httpClient.tls.key`           | Path to a TLS key file                                                                 | `""`                                          |
| `taalbot.redis.address`                | Address of the Redis server used as message broker                                     | `""`                                          |
| `taalbot.redis.secretName`             | Name of the secret containing Redis password                                           | `""`                                          |
| `taalbot.redis.secretPasswordKey`      | Name of the key holding the password within the secret                                 | `""`                                          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```console
$ helm install --name my-release \
  --set taalbot.secretName=secret \
    ./helm-charts/taalbot
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml ./helm-charts/taalbot
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## API server URL

The `taalbot.apiServerURL` parameter must point to a working `taalapi` instance.

## Secrets

This chart relies on a secret that must contain at least one key, `bot-token`,
with plain-text token obtained from Discord Developer Portal. See Discord
[documentation](https://discord.com/developers/docs/topics/oauth2#bots) for more
information.

## Redis

Taalbot uses Redis message broker capabilities to implement a PubSub message
queue between components.

You need to set the `taalbot.redis.address` parameter with the address to a
running Redis server, as well as the `taalbot.redis.secretName` and
`taalbot.redis.secretPasswordKey` parameters, respectively corresponding to the
name of the secret and the name of the key containing the Redis password.

## Liveness and readiness probes

As of now, this chart does not set any liveness or readiness probes by default,
but you can set them yourself, by overriding the corresponding parameters.
