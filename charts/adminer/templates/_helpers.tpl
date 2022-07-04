{{/* Generate adminer deployment envs */}}
{{- define "adminer.envs" }}
env:
{{- range $key, $value := .Values.environment }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{/* Generate adminer deployment limits */}}
{{- define "adminer.limits" }}
{{- if or (.Values.limits_cpu) (.Values.limits_memory) }}
resources:
  limits:
{{- if (.Values.limits_cpu) }}
    cpu: {{.Values.limits_cpu}}
{{- end }}
{{- if (.Values.limits_memory) }}
    memory: {{.Values.limits_memory}}
{{- end }}
{{- end }}
{{- end }}


{{/* Generate adminer deployment volumeMounts */}}
{{- define "adminer.volumeMounts" }}
{{- if .Values.persistence.enabled }}
volumeMounts:
- name: adminer-data
  mountPath: /drycc/php-fpm
  subPath: php-fpm
- name: adminer-data
  mountPath: /drycc/nginx
  subPath: nginx
- name: adminer-data
  mountPath: /drycc/vouch-proxy
  subPath: vouch-proxy
{{- end }}
{{- end }}

{{/* Generate adminer deployment volumes */}}
{{- define "adminer.volumes" }}

{{- if .Values.persistence.enabled }}
volumes:
- name: adminer-data
  persistentVolumeClaim:
    claimName: drycc-adminer
{{- end }}
{{- end }}
