# taalapi

`taalapi` is the backend component for `taalbot`.

## TL;DR;

```console
$ helm install ./helm-charts/taalapi
```

## Introduction

This chart bootstraps a [taalbot](https://github.com/SpecialFlocon/taalbot)
backend deployment on a [Kubernetes](http://kubernetes.io) cluster using the
[Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+
- A running MongoDB database and its user credentials

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release ./helm-charts/taalapi
```

The command deploys taalapi on the Kubernetes cluster in the default
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

The following table lists the configurable parameters of the taalapi chart and
their default values.

|                  Parameter                    |                                           Description                                     |                   Default                     |
|-----------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------------------------|
| `imagePullSecrets`                            | Specify image pull secrets                                                                | `[]`                                          |
| `extraLabels`                                 | Labels to add to resources                                                                | `{}`                                          |
| `taalapi.image.registry`                      | taalapi image registry                                                                    | `docker.io`                                   |
| `taalapi.image.repository`                    | taalapi image name                                                                        | `specialflocon/taalapi`                       |
| `taalapi.image.tag`                           | taalapi image tag                                                                         | `.Chart.AppVersion`                           |
| `taalapi.image.pullPolicy`                    | Image pull policy                                                                         | `Always`                                      |
| `taalapi.image.args`                          | Container entrypoint arguments                                                            | `["run"]`                                     |
| `taalapi.application.dashboardURL`            | Public URL of taaldashboard, used for redirections.                                       | `""`                                          |
| `taalapi.application.debug`                   | Whether taalapi runs in debug mode or not (see below)                                     | `""`                                          |
| `taalapi.application.publicURL`               | Public URL of taalapi, serving API, auth endpoints and web dashboard                      | `""`                                          |
| `taalapi.httpServer.allowedOrigins`           | List of origins (domains) allowed to make HTTP requests to the server, separated by space | `""`                                          |
| `taalapi.httpServer.socketAddress.address`    | Listen address of taalapi HTTP server                                                     | `""`                                          |
| `taalapi.httpServer.socketAddress.portNumber` | Listen port of taalapi HTTP server                                                        | `""`                                          |
| `taalapi.httpServer.spa.serve`                | Enable/disable serving taaldashboard SPA                                                  | `""`                                          |
| `taalapi.httpServer.spa.filesystemPath`       | Filesystem path of the directory containing the SPA files                                 | `""`                                          |
| `taalapi.httpServer.tls.enabled`              | Enable/disable TLS                                                                        | `""`                                          |
| `taalapi.httpServer.tls.secretName`           | Name of the secret containing TLS certificate chain files                                 | `""`                                          |
| `taalapi.httpServer.tls.mountPath`            | Mountpoint of the TLS secret within the container                                         | `""`                                          |
| `taalapi.httpServer.tls.caCert`               | Path to a TLS CA certificate file                                                         | `""`                                          |
| `taalapi.httpServer.tls.cert`                 | Path to a TLS certificate file                                                            | `""`                                          |
| `taalapi.httpServer.tls.key`                  | Path to a TLS key file                                                                    | `""`                                          |
| `taalapi.livenessProbe`                       | taalapi liveness probe                                                                    | See `values.yaml`                             |
| `taalapi.readinessProbe`                      | taalapi readiness probe                                                                   | See `values.yaml`                             |
| `taalapi.resources.limits`                    | taalapi CPU/memory resource limits                                                        | Memory: `256Mi`, CPU: `200m`                  |
| `taalapi.resources.requests`                  | taalapi CPU/memory resource requests                                                      | Memory: `256Mi`, CPU: `200m`                  |
| `taalapi.mongodb.address`                     | Address of the MongoDB server used to store taalapi data                                  | `""`                                          |
| `taalapi.mongodb.database`                    | Name of the database                                                                      | `""`                                          |
| `taalapi.mongodb.username`                    | Name of the database user                                                                 | `""`                                          |
| `taalapi.mongodb.secretName`                  | Name of the secret containing database password                                           | `""`                                          |
| `taalapi.mongodb.secretPasswordKey`           | Name of the key holding the password within the secret                                    | `""`                                          |
| `taalapi.secretName`                          | Name of the secret containing taalapi secret data                                         | `""`                                          |
| `taalapi.service.enabled`                     | Enable/disable taalapi service                                                            | `true`                                        |
| `taalapi.service.ports.http`                  | Service port number for taalapi HTTP server (see below)                                   | `8080`                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example,

```console
$ helm install --name my-release \
  --set taalapi.secretName=secrets \
  ./helm-charts/taalapi
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml ./helm-charts/taalapi
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Allowed origins

The `taalapi.httpServer.allowedOrigins` parameter can be used to define a list
of trusted origins. Values defined there will be used by the CORS and
CSRF middlewares to determine whether the origin is allowed to make HTTP
requests to the server or not.

## Debug mode

The chart has a `taalapi.application.debug` parameter, which when set to true,
makes the CORS middleware allow all origins, and disables CSRF protection
entirely.

## Service ports

`taalapi` runs a HTTP server, which listens on address specified in
`taalapi.httpServer.socketAddress`.

## Dashboard

`taaldashboard` is Taalbot administration single-page application that can be
served by `taalapi`.

The `taalapi.httpServer.spa.serve` parameter can be used to enable or disable
serving the SPA. The `taalapi.httpServer.spa.filesystemPath` parameter gives
`taalapi` the path to the directory containing the SPA files.

## Public URL

The `taalapi.application.publicURL` parameter contains the URL that clients can
use to reach taalapi. If not set, the application will fallback to
`http://localhost:8080`, so make sure to change it according to your needs.

## Secret data

taalapi relies on secret data to work correctly, which must be stored in a
Kubernetes secret which name is set in the `taalapi.secretName` parameter. The
subsection below explains which keys must be present in the secret.

### Cookie secrets

Some taalapi components rely on HTTP cookies: session cookies for OAuth 2 proxy,
and CSRF tokens for CSRF middleware. Session cookies are encrypted using AES
and signed using HMAC, while CSRF token cookies are only signed. The secret
values used to encrypt and sign cookies must therefore be stored in the
`cookie-encrypt-key` and `cookie-sign-key` fields of the secret.

Both keys should be randomly generated. The encryption key must be 16, 24 or 32
bytes long, and the signing key should be at least 32 bytes long.

Keys will be available as environment variables
`TAALAPI_COOKIES_ENCRYPTION_SECRET` and `TAALAPI_COOKIES_SIGNING_SECRET`.

### Discord OAuth 2 provider

taalapi uses Discord as an OAuth 2 authorization provider. For this to work, the
secret must contain two fields: `oauth2-client-id` and `oauth2-client-secret`,
which correspond to values obtained from the Discord Developer Portal. Both
strings will be available as environment variables
`TAALAPI_DISCORD_OAUTH2_CLIENT_ID` and `TAALAPI_DISCORD_OAUTH2_CLIENT_SECRET`.

## MongoDB

taalapi stores its data in a MongoDB database. You need to point it towards a
MongoDB instance using the `taalapi.mongodb.*` parameters.

To let taalapi authenticate to MongoDB, you need to set the
`taalapi.mongodb.existingSecret` and `taalapi.mongodb.secretPasswordKey`
parameters, respectively corresponding to the name of the Kubernetes secret
containing MongoDB credentials and the name of the key containing the database
password.
