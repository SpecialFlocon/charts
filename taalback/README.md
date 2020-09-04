# taalback

`taalbot` is a resident Discord bot in a Dutch language learning server.
`taalback` is its backend component.

## TL;DR;

```console
$ helm install ./helm-charts/taalback
```

## Introduction

This chart bootstraps a [taalback](https://github.com/SpecialFlocon/taalback)
deployment on a [Kubernetes](http://kubernetes.io) cluster using the
[Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+
- A running MongoDB database and its user credentials

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release ./helm-charts/taalback
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

The following table lists the configurable parameters of the `taalback` chart
and their default values.

|              Parameter                 |                                      Description                                       |                   Default                     |
|----------------------------------------|----------------------------------------------------------------------------------------|-----------------------------------------------|
| `imagePullSecrets`                     | Specify image pull secrets                                                             | `[]`                                          |
| `extraLabels`                          | Labels to add to resources                                                             | `{}`                                          |
| `taalback.image.registry`              | taalbot image registry                                                                 | `docker.io`                                   |
| `taalback.image.repository`            | taalbot image name                                                                     | `specialflocon/taalbot`                       |
| `taalback.image.tag`                   | taalbot image tag                                                                      | `.Chart.AppVersion`                           |
| `taalback.image.pullPolicy`            | Image pull policy                                                                      | `Always`                                      |
| `taalback.image.args`                  | Container entrypoint arguments                                                         | `["run"]`                                     |
| `taalback.resources.limits`            | Container CPU/memory resource limits                                                   | Memory: `64Mi`, CPU: `100m`                   |
| `taalback.resources.requests`          | Container CPU/memory resource requests                                                 | Memory: `64Mi`, CPU: `100m`                   |
| `taalback.livenessProbe`               | Container liveness probe                                                               | See `values.yaml`                             |
| `taalback.readinessProbe`              | Container readiness probe                                                              | See `values.yaml`                             |
| `taalback.secretName`                  | Name of the secret containing taalbot secret data                                      | `""`                                          |
| `taalback.mongodb.address`             | MongoDB server address                                                                 | `""`                                          |
| `taalback.mongodb.database`            | MongoDB database name                                                                  | `""`                                          |
| `taalback.mongodb.username`            | MongoDB database username                                                              | `""`                                          |
| `taalback.mongodb.secretName`          | Name of the secret containing MongoDB password                                         | `""`                                          |
| `taalback.mongodb.secretPasswordKey`   | Name of the key within the secret containing MongoDB password                          | `""`                                          |
| `taalback.server.listenAddress`        | Listening address of the HTTP server                                                   | `""`                                          |
| `taalback.server.listenPort`           | Listening port of the HTTP server                                                      | `""`                                          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```console
$ helm install --name my-release \
  --set taalback.secretName=secret \
    ./helm-charts/taalback
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml ./helm-charts/taalback
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Secrets

This chart relies on a secret that must contain the MongoDB database password in
a key, which name you can specify in `taalback.mongodb.secretPasswordKey`.

## Liveness and readiness probes

As of now, this chart does not set any liveness or readiness probes by default,
but you can set them yourself, by overriding the corresponding parameters.
