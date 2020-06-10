{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "taalbot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified domain name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "taalbot.fullname" -}}
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
{{- define "taalbot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper taalbot image name
*/}}
{{- define "taalbot.image" -}}
{{- $tag := .Values.taalbot.image.tag | default .Chart.AppVersion | toString -}}
{{- printf "%s/%s:%s" .Values.taalbot.image.registry .Values.taalbot.image.repository $tag -}}
{{- end -}}

{{/*
Return common labels.
*/}}
{{- define "taalbot.commonLabels" -}}
app.kubernetes.io/name: {{ include "taalbot.name" . }}
helm.sh/chart: {{ include "taalbot.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return selector labels.
*/}}
{{- define "taalbot.selectorLabels" -}}
app.kubernetes.io/name: {{ include "taalbot.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return formatted HTTP server listen address.
*/}}
{{- define "taalbot.httpServer.listenAddress" -}}
{{- printf "%s:%d" .Values.taalbot.httpServer.socketAddress.address (.Values.taalbot.httpServer.socketAddress.portNumber | int) | quote -}}
{{- end -}}
