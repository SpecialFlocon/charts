{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "taalapi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified domain name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "taalapi.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "taalapi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper taalapi image name
*/}}
{{- define "taalapi.image" -}}
{{- $tag := .Values.taalapi.image.tag | default .Chart.AppVersion | toString -}}
{{- printf "%s/%s:%s" .Values.taalapi.image.registry .Values.taalapi.image.repository $tag -}}
{{- end -}}

{{/*
Return common labels.
*/}}
{{- define "taalapi.commonLabels" -}}
app.kubernetes.io/name: {{ include "taalapi.name" . }}
helm.sh/chart: {{ include "taalapi.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return selector labels.
*/}}
{{- define "taalapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "taalapi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return formatted HTTP server listen address.
*/}}
{{- define "taalapi.httpServer.listenAddress" -}}
{{- printf "%s:%d" .Values.taalapi.httpServer.socketAddress.address (.Values.taalapi.httpServer.socketAddress.portNumber | int) | quote -}}
{{- end -}}
