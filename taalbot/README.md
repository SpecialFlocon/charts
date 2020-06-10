# taalbot

`taalbot` is a Discord bot made for a Dutch language learning server.

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

|                  Parameter                    |                                           Description                                     |                   Default                     |
|-----------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------------------------|
| `imagePullSecrets`                            | Specify image pull secrets                                                                | `[]`                                          |
| `extraLabels`                                 | Labels to add to resources                                                                | `{}`                                          |
| `taalbot.image.registry`                      | taalbot image registry                                                                    | `docker.io`                                   |
| `taalbot.image.repository`                    | taalbot image name                                                                        | `specialflocon/taalbot`                       |
| `taalbot.image.tag`                           | taalbot image tag                                                                         | `.Chart.AppVersion`                           |
| `taalbot.image.pullPolicy`                    | Image pull policy                                                                         | `Always`                                      |
| `taalbot.image.args`                          | Container entrypoint arguments                                                            | `["run"]`                                     |
| `taalbot.application.debug`                   | Whether taalbot runs in debug mode or not (see below)                                     | `""`                                          |
| `taalbot.application.publicURL`               | Public URL of taalbot, serving API, auth endpoints and web dashboard                      | `""`                                          |
| `taalbot.httpServer.allowedOrigins`           | List of origins (domains) allowed to make HTTP requests to the server, separated by space | `""`                                          |
| `taalbot.httpServer.socketAddress.address`    | Listen address of taalbot HTTP server                                                     | `""`                                          |
| `taalbot.httpServer.socketAddress.portNumber` | Listen port of taalbot HTTP server                                                        | `""`                                          |
| `taalbot.httpServer.tls.enabled`              | Enable/disable TLS                                                                        | `""`                                          |
| `taalbot.httpServer.tls.secretName`           | Name of the secret containing TLS certificate chain files                                 | `""`                                          |
| `taalbot.httpServer.tls.mountPath`            | Mountpoint of the TLS secret within the container                                         | `""`                                          |
| `taalbot.httpServer.tls.caCert`               | Path to a TLS CA certificate file                                                         | `""`                                          |
| `taalbot.httpServer.tls.cert`                 | Path to a TLS certificate file                                                            | `""`                                          |
| `taalbot.httpServer.tls.key`                  | Path to a TLS key file                                                                    | `""`                                          |
| `taalbot.livenessProbe`                       | taalbot liveness probe                                                                    | See `values.yaml`                             |
| `taalbot.readinessProbe`                      | taalbot readiness probe                                                                   | See `values.yaml`                             |
| `taalbot.resources.limits`                    | taalbot CPU/memory resource limits                                                        | Memory: `256Mi`, CPU: `200m`                  |
| `taalbot.resources.requests`                  | taalbot CPU/memory resource requests                                                      | Memory: `64Mi`, CPU: `50m`                    |
| `taalbot.mongodb.address`                     | Address of the MongoDB server used to store taalbot data                                  | `""`                                          |
| `taalbot.mongodb.database`                    | Name of the database                                                                      | `""`                                          |
| `taalbot.mongodb.username`                    | Name of the database user                                                                 | `""`                                          |
| `taalbot.mongodb.secretName`                  | Name of the secret containing database password                                           | `""`                                          |
| `taalbot.mongodb.secretPasswordKey`           | Name of the key holding the password within the secret                                    | `""`                                          |
| `taalbot.secretName`                          | Name of the secret containing taalbot secret data                                         | `""`                                          |
| `taalbot.service.enabled`                     | Enable/disable taalbot service                                                            | `true`                                        |
| `taalbot.service.ports.http`                  | Service port number for taalbot HTTP server (see below)                                   | `8080`                                        |
| `taalbot.webapp.assetsDirectory`              | Filesystem path of directory containing web application static assets                     | `""`                                          |
| `taalbot.webapp.templatesDirectory`           | Filesystem path of directory containing web application HTML templates                    | `""`                                          |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example,

```console
$ helm install --name my-release \
  --set taalbot.secretName=secrets \
  ./helm-charts/taalbot
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml ./helm-charts/taalbot
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Allowed origins

The `taalbot.httpServer.allowedOrigins` parameter can be used to define a list
of trusted origins. Values defined there will be used by the CORS and
CSRF middlewares to determine whether the origin is allowed to make HTTP
requests to the server or not.

## Debug mode

The chart has a `taalbot.application.debug` parameter, which when set to true,
makes the CORS middleware allow all origins, and disables CSRF protection
entirely.

## Service ports

`taalbot` runs a HTTP server, which listens on address specified in
`taalbot.httpServer.socketAddress`.

## Dashboard

`taaldashboard` is the web-based administration application.

The `taalbot.webapp.assetsDirectory` and `taalbot.webapp.templatesDirectory` are
respectively paths of directories to static assets and HTML templates used by
the web application, and must be set according to your setup.

## Public URL

The `taalbot.application.publicURL` parameter contains the URL that clients can
use to reach taalbot. If not set, the application will fallback to
`http://localhost:8080`, so make sure to change it according to your needs.

## Secret data

taalbot relies on secret data to work correctly, which must be stored in a
Kubernetes secret which name is set in the `taalbot.secretName` parameter. The
subsection below explains which keys must be present in the secret.

### Cookie secrets

Some taalbot components rely on HTTP cookies: session cookies for OAuth 2 proxy,
and CSRF tokens for CSRF middleware. Session cookies are encrypted using AES
and signed using HMAC, while CSRF token cookies are only signed. The secret
values used to encrypt and sign cookies must therefore be stored in the
`cookie-encrypt-key` and `cookie-sign-key` fields of the secret.

Both keys should be randomly generated. The encryption key must be 16, 24 or 32
bytes long, and the signing key should be at least 32 bytes long.

Keys will be available as environment variables
`TAALBOT_COOKIES_ENCRYPTION_SECRET` and `TAALBOT_COOKIES_SIGNING_SECRET`.

### Discord bot token

The secret must also contain a bot token obtained from Discord Developer Portal,
stored in the `bot-token` field.

### Discord OAuth 2 provider

taalbot uses Discord as an OAuth 2 authorization provider. For this to work, the
secret must contain two fields: `oauth2-client-id` and `oauth2-client-secret`,
which correspond to values obtained from the Discord Developer Portal. Both
strings will be available as environment variables
`TAALBOT_DISCORD_OAUTH2_CLIENT_ID` and `TAALBOT_DISCORD_OAUTH2_CLIENT_SECRET`.

## MongoDB

taalbot stores its data in a MongoDB database. You need to point it towards a
MongoDB instance using the `taalbot.mongodb.*` parameters.

To let taalbot authenticate to MongoDB, you need to set the
`taalbot.mongodb.existingSecret` and `taalbot.mongodb.secretPasswordKey`
parameters, respectively corresponding to the name of the Kubernetes secret
containing MongoDB credentials and the name of the key containing the database
password.
