{{- if .Values.migration.enabled -}}

apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "app.fullname" . }}-migration
spec:
  template:
    metadata:
      labels:
        {{- include "app.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ include "app.fullname" . }}-migration
          image: migrations
          imagePullPolicy: Always
          {{- with .Values.migration.command }}
          command:
            - {{ $key }}
          {{- end }}
          {{- with .Values.migration.args }}
          args:
            - {{ $key }}
          {{-end }}
          env:
            {{- range $key, $value := . }}
            - name: {{ $key }}
              value: {{ $value | quote }}
            {{- end }}
          {{- end }}
          envFrom:
            {{- with .Values.envFrom }}
            {{- toYaml . | nindent 12 }}
            {{- end }}
          {{- with .Values.migration.resources }}
          resources:
            {{- toYaml . | nindent 12 }}
          {{- end }}
      restartPolicy: Never
      activeDeadlineSeconds: 240 # 4 minutes

{{- end }}
