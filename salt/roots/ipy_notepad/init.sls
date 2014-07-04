#
# Set up the backend environment for development or production.
#
{% set local_user = pillar['pp']['admin']['user'] %}
{% set local_group = pillar['pp']['admin']['group'] %}
{% set dev_env =  pillar['pp']['dev_virtualenv'] %}

#
# Setup virtualenv using option system_site_packages = True,
# to allow access to numpy etc.
#

{{ "pythonenv-{}".format(dev_env) }}:
  virtualenv.manage:
    - name: /home/{{ local_user }}/.virtualenvs/{{ dev_env }}
    - runas: {{ local_user }}
    - distribute: true
    - system_site_packages: True
#
# Install a stack of numerical Python packages into the system
# Python to avoid having to compile them each time.
#
{% set packages = [
	'python-numpy',
	'python-scipy',
	'python-matplotlib',
	'ipython',
  'ipython-doc',
  'ipython-qtconsole',
  'ipython-notebook',
	'python-pandas',
	'python-sympy',
	'python-nose'
] %}
{% for dep in packages %}
{{ dep }}:
  pkg:
    - installed
{% endfor %}


# Set up nginx and the hostname & proxy pass magic:
nginx:
  pkg:
    - installed
  service:
    - running
    - watch:
        - file: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default:
    file.managed:
        - replace: true
        - source: salt://ipy_notepad/templates/dev-vhost.conf
        - template: jinja
        - mode: 644
        - context:
            server_name: {{ pillar['ipynotepad']['server_name'] }}
            ipynotepad_proxyuri: {{ pillar['ipynotepad']['proxy_uri'] }}
            read_timeout: {{ pillar['pp']['read_timeout'] }}
        - require:
            - pkg: nginx


{{ pillar['ipynotepad']['upstart_config'] }}:
  file.managed:
    - name: {{ pillar['ipynotepad']['upstart_config'] }}
    - replace: true
    - source: salt://services/templates/upstart-service-template.conf
    - template: jinja
    - mode: 644
    - context:
      service_name: {{ pillar['ipynotepad']['service_name'] }}
      run_as: {{ pillar['ipynotepad']['run_as'] }}
      command_line: {{ pillar['ipynotepad']['command_line'] }}
      log_file: {{ pillar['ipynotepad']['log_file'] }}
  service:
    - running
    - name: {{ pillar['ipynotepad']['service_name'] }}
    - enable: True
    - require:
        - file: {{ pillar['ipynotepad']['upstart_config'] }}

