{%- from "linux/map.jinja" import system with context %}
{%- if system.enabled %}

{%- for name, service in system.service.items() %}

{%- if service.status is list %}
{%- for servicestatus in service.status.items() %}
linux_service_{{ name }}_{{ servicestatus }}:
  service.{{ servicestatus }}:
  {%- if servicestatus == 'dead' %}
  - enable: {{ service.get('enabled', False) }}
  {%- elif servicestatus == 'running' %}
  - enable: {{ service.get('enabled', True) }}
  {%- endif %}
  - name: {{ name }}
{%- endfor %}
{%- else %}
linux_service_{{ name }}:
  service.{{ service.status }}:
  {%- if service.status == 'dead' %}
  - enable: {{ service.get('enabled', False) }}
  {%- elif service.status == 'running' %}
  - enable: {{ service.get('enabled', True) }}
  {%- endif %}
  - name: {{ name }}

{%- endif %}
{%- endfor %}
{%- endif %}
