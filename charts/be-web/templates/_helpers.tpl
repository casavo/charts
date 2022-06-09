{{/*
Expand the name of the release.
*/}}
{{- define "app.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Hook selector labels
*/}}
{{- define "app.hookSelectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" .globals }}
app.kubernetes.io/instance: hook-{{ .hook.name | replace "_" "-" }}
{{- end }}

{{/*
Cron selector labels
*/}}
{{- define "app.cronSelectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" .globals }}
app.kubernetes.io/instance: cron-{{ .name | replace "_" "-" }}
{{- end }}

{{/*
Worker selector labels
*/}}
{{- define "app.workerSelectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" .globals }}
app.kubernetes.io/instance: worker-{{ .name | replace "_" "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.baseLabels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "app.selectorLabels" . }}
{{- if .Values.image.tag }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Base labels
*/}}
{{- define "app.labels" -}}
{{ include "app.baseLabels" . }}
app: {{ include "app.name" . }}
{{- end }}

{{/*
Hook labels
*/}}
{{- define "app.hookLabels" -}}
helm.sh/chart: {{ include "app.chart" .globals }}
{{ include "app.hookSelectorLabels" . }}
{{- if .globals.Values.image.tag }}
app.kubernetes.io/version: {{ .globals.Values.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .globals.Release.Service }}
app: {{ include "app.name" .globals }}-hook-{{ .hook.name | replace "_" "-" }}
{{- with .globals.Values.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Cron labels
*/}}
{{- define "app.cronLabels" -}}
helm.sh/chart: {{ include "app.chart" .globals }}
{{ include "app.cronSelectorLabels" . }}
{{- if .globals.Values.image.tag }}
app.kubernetes.io/version: {{ .globals.Values.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .globals.Release.Service }}
app: {{ include "app.name" .globals }}-cron-{{ .name | replace "_" "-" }}
{{- with .globals.Values.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Worker labels
*/}}
{{- define "app.workerLabels" -}}
helm.sh/chart: {{ include "app.chart" .globals }}
{{ include "app.workerSelectorLabels" . }}
{{- if .globals.Values.image.tag }}
app.kubernetes.io/version: {{ .globals.Values.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .globals.Release.Service }}
app: {{ include "app.name" .globals }}-worker-{{ .name | replace "_" "-" }}
{{- with .globals.Values.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}
