#
# This sets up docker and the various services running under
#
# Oisin Mulvihill
# 2014-03-05
#
include:
    - systemtools

{% set local_user = pillar['pp']['admin']['user'] %}
{% set local_group = pillar['pp']['admin']['group'] %}
{% set image_uri_base = 'dev' %}
{% set salt_image_base = '/salt/image_build' %}

{% set packages = ['git', 'mercurial', 'htop'] %}
{% for dep in packages %}
{{ dep }}:
  pkg:
    - installed
{% endfor %}
