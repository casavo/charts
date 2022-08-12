{{- if semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: batch/v1
{{- else -}}
apiVersion: batch/v1beta1
{{- end }}

kind: CronJob
metadata:
  name: {{ include "app.fullname" . }}
spec:
  schedule: "{{ .Values.schedule }}"
  concurrencyPolicy: {{ .Values.concurrencyPolicy }}
  startingDeadlineSeconds: {{ .Values.startingDeadlineSeconds }}
  suspend: {{ .Values.suspend }}
  jobTemplate:
    spec:
      backoffLimit: {{ .Values.backoffLimit }}
      template:
        spec:
          {{- with .Values.image.pullSecrets }}
          imagePullSecrets:
            {{- toYaml . | nindent 8 }}
          {{- end }}
          containers:
            - name: {{ .Chart.Name }}
              image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
              imagePullPolicy: {{ .Values.image.pullPolicy }}
              envFrom:
                {{- with .Values.envFrom }}
                {{- toYaml . | nindent 14 }}
                {{- end }}
              - configMapRef:
                  name: {{ include "app.fullname" . }}
          restartPolicy: {{ .Values.restartPolicy }}
