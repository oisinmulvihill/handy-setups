#
# Install compilers and python tools needed for development. Ported from the
# original puppet devtools module.
#
# Oisin Mulvihill
# 2014-01-31
#
{% set deb_packages = [
    'build-essential',
    'python',
    'python-dev',
    'python-pip',
    'zip',
    'unzip'
] %}
{% for dep in deb_packages %}
{{ dep }}:
  pkg:
    - installed
{% endfor %}

# These are python things that are too old / unavailable in debian
{% set py_packages = [
    'pip>=1.4',
    'virtualenv>=1.11.4',
    'virtualenvwrapper',
] %}
{% for dep in py_packages %}
{{ dep }}:
  pip.installed:
    - require:
      - pkg: python-pip
{% endfor %}

