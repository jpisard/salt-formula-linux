{%- from "linux/map.jinja" import system with context -%}
--     DO NOT EDIT THIS FILE BY HAND __ YOUR CHANGES WILL BE OVERWRITTEN BY SALTSTACK
synchrodef={}
{%- for name, module in system.lsyncd.module.iteritems() %}
{%- if module.delay is defined %}
{%- set module_delay = module.delay %}
{%- else %}
{%- set module_delay = 0 %}
{%- endif %}
{%- if module.delete is defined %}
{%- set module_delete = module.delete %}
{%- else %}
{%- set module_delete = true %}
{%- endif %}
{%- if module.compress is defined %}
{% set module_compress = module.compress %}
{%- else %}
{%- set module_compress = true %}
{%- endif %}
{%- if ( module["update"] is defined and ( module["update"] == true or module["update"] == false ) ) %}
{%- set module_update = module["update"] %}
{%- else %}
{%- set module_update = true %}
{%- endif %}
{%- if module.perms is defined %}
{%- set module_perms = module.perms %}
{%- else %}
{%- set module_perms = true %}
{%- endif %}

{%- if module.exclude is defined %}
{%- set module_exclude = ',["exclude"]={"' ~ module.exclude|join('", "')|string() ~ '"}' %}
{%- else %}
{%- set module_exclude = '' %}
{%- endif %}

{%- if module._extra is defined %}
{%- set module_extra = ',["_extra"]={"' ~ module._extra|join('", "')|string() ~ '"}' %}
{%- else %}
{%- set module_extra = '' %}
{%- endif %}

{%- if module.targetlist is defined %}
{%- set module_targetlist = module.targetlist|join('", "')|string()  %}
{%- else %}
{%- set module_targetlist = false %}
{%- endif %}

{%- if module_targetlist %}
synchrodef["{{ name }}"]={ ["targetlist"]={ "{{ module_targetlist }}",}{{ module_exclude }},["delay"]={{ module_delay }},["delete"]={{ module_delete }},["compress"]={{ module_compress }},["update"]={{ module_update }},["perms"]={{ module_perms }}{{ module_extra }} }
{%- endif %}

{%- endfor %}
return synchrodef
