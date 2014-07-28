#
{% set local_user = pillar['pp']['admin']['user'] %}
{% set local_group = pillar['pp']['admin']['group'] %}

{% set packages = [
    'git',
    'mercurial',
    'htop',
    'python-software-properties',
    'python-pip',
] %}
{% for dep in deb_packages %}
{{ dep }}:
  pkg:
    - installed
{% endfor %}

# Allow sudo-less calls to docker for the vagrant user:
{{ "{}-docker-rights".format(local_user) }}:
    cmd.run:
        - name: sudo gpasswd -a {{ local_user }} docker
        - unless: groups {{ local_user }} | grep docker


{% set py_packages = [
    'docker-py',
] %}
{% for dep in py_packages %}
{{ dep }}:
  pip.installed:
    - require:
      - pkg: python-pip
{% endfor %}
