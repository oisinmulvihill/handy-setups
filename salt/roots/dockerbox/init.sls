#
{% set local_user = pillar['pp']['admin']['user'] %}
{% set local_group = pillar['pp']['admin']['group'] %}

{% set deb_packages = [
    'git',
    'mercurial',
    'htop',
] %}
{% for dep in deb_packages %}
{{ dep }}:
  pkg:
    - installed
{% endfor %}


{% set py_packages = [
    'docker-py',
] %}
{% for dep in py_packages %}
{{ dep }}:
  pip.installed:
    - require:
      - pkg: python-pip
{% endfor %}

#add docker
docker:
  group.present:
    - members:
      - {{ local_user }}

# Ubuntu 14.04 LTS docker set up:
#  - http://docs.docker.com/installation/ubuntulinux/
#
docker.io:
  pkg:
    - installed
    - require:
      - pip: docker-py
  service:
    - running
    - enable: True
    - reload: True
    - require:
      - group: docker
    - watch:
      - pkg: docker.io


# set up the symlink involved:
/usr/local/bin/docker:
  file.symlink:
    - target: /usr/bin/docker.io
    - require:
      - pkg: docker.io


# Allow sudo-less calls to docker for the vagrant user:
{{ "{}-docker-rights".format(local_user) }}:
  cmd.run:
    - name: sudo gpasswd -a {{ local_user }} docker
    - unless: groups {{ local_user }} | grep docker
    - require:
      - pkg: docker.io

