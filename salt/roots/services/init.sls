#
# This sets up docker and the various services running under
#
# Oisin Mulvihill
# 2014-03-05
#
include:
    - systemtools
    - docker

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

# Allow sudo-less calls to docker for the vagrant user:
{{ "{}-docker-rights".format(local_user) }}:
    cmd.run:
        - name: sudo gpasswd -a {{ local_user }} docker
        - unless: groups {{ local_user }} | grep docker


# Set up the directory I'm going to use for the the logs and data files which
# will be mounted inside the mongo container.
{% set required_directories = [
] %}
{% for (required_dir) in required_directories %}

{{ required_dir }}:
  file.directory:
    - mode: 755
    - makedirs: True

{% endfor %}
