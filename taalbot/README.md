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
- A running MongoDB database and its user credentials
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
| `taalbot.image.args`                   | Container entrypoint arguments                                                         | `["run"]`                                     |
| `taalbot.resources.limits`             | Container CPU/memory resource limits                                                   | Memory: `64Mi`, CPU: `100m`                   |
| `taalbot.resources.requests`           | Container CPU/memory resource requests                                                 | Memory: `64Mi`, CPU: `100m`                   |
| `taalbot.livenessProbe`                | Container liveness probe                                                               | See `values.yaml`                             |
| `taalbot.readinessProbe`               | Container readiness probe                                                              | See `values.yaml`                             |
| `taalbot.secretName`                   | Name of the secret containing taalbot secret data                                      | `""`                                          |
| `taalbot.bot.commandPrefix`            | Command prefix used to invoke the bot in the Discord server (e.g. "?", "!")            | `""`                                          |
| `taalbot.bot.ownerID`                  | ID of the bot owner                                                                    | `""`                                          |
| `taalbot.mongodb.address`              | MongoDB server address                                                                 | `""`                                          |
| `taalbot.mongodb.database`             | MongoDB database name                                                                  | `""`                                          |
| `taalbot.mongodb.username`             | MongoDB database username                                                              | `""`                                          |
| `taalbot.mongodb.secretName`           | Name of the secret containing MongoDB password                                         | `""`                                          |
| `taalbot.mongodb.secretPasswordKey`    | Name of the key within the secret containing MongoDB password                          | `""`                                          |
| `taalbot.server.logChannel`            | ID of the bot log channel                                                              | `""`                                          |


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

## Secrets

This chart relies on a secret that must contain at least one key, `bot-token`,
with plain-text token obtained from Discord Developer Portal. See Discord
[documentation](https://discord.com/developers/docs/topics/oauth2#bots) for more
information.

## Liveness and readiness probes

As of now, this chart does not set any liveness or readiness probes by default,
but you can set them yourself, by overriding the corresponding parameters.
