{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "taalback.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified domain name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "taalback.fullname" -}}
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
{{- define "taalback.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper taalback image name
*/}}
{{- define "taalback.image" -}}
{{- $tag := .Values.taalback.image.tag | default .Chart.AppVersion | toString -}}
{{- printf "%s/%s:%s" .Values.taalback.image.registry .Values.taalback.image.repository $tag -}}
{{- end -}}

{{/*
Return common labels.
*/}}
{{- define "taalback.commonLabels" -}}
app.kubernetes.io/name: {{ include "taalback.name" . }}
helm.sh/chart: {{ include "taalback.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return selector labels.
*/}}
{{- define "taalback.selectorLabels" -}}
app.kubernetes.io/name: {{ include "taalback.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
