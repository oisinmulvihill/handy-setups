#
# Ported from the puppet module vagrant_user.
#
# Oisin Mulvihill
# 2014-01-31
#

# Some variables I want to use in this file:
#
{% set local_user = pillar['pp']['admin']['user'] %}
{% set local_group = pillar['pp']['admin']['group'] %}
{% set scriptlibdir = pillar['pp']['admin']['scriptlibdir'] %}


# Loop through the dependancies I like to have around:
#
{% set packages = ['vim', 'bash', 'screen', 'curl'] %}
{% for dep in packages %}
{{ dep }}:
  pkg:
    - installed
{% endfor %}


# Set up the non-template files:
#
{% set dot_files = [
    ('vimrc', '/home/{}/.vimrc'.format(local_user)),
    ('gemrc', '/home/{}/.gemrc'.format(local_user)),
    ('sqliterc', '/home/{}/.sqliterc'.format(local_user)),
    ('toprc', '/home/{}/.toprc'.format(local_user)),
    ('environment', '/etc/environment'),
    ('bashrc', '/home/{}/.bashrc'.format(local_user)),
    ('bash_profile', '/home/{}/.bash_profile'.format(local_user)),
    ('gitconfig', '/home/{}/.gitconfig'.format(local_user)),

] %}
{% for (template, dest_path) in dot_files %}
{{ dest_path }}:
    file.managed:
        - replace: True
        - user: {{ local_user }}
        - group: {{ local_group }}
        - source: {{ "salt://admin_user/templates/{}".format(template) }}
        - context:
            scriptlibdir: {{ scriptlibdir }}
        - template: jinja
        - mode: 644

{% endfor %}


{{ scriptlibdir }}:
  file.directory:
    - user: {{ local_user }}
    - group: {{ local_group }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode


{{ '{}/developer-tools.sh'.format(scriptlibdir) }}:
    file:
        - managed
        - source: salt://admin_user/templates/developer-tools.sh
        - user: {{ local_user }}
        - group: {{ local_group }}
        - mode: 744
        - context:
            dt_help_txt_file: {{ '/home/{}/.dthelptext'.format(local_user) }}
        - template: jinja
        - require:
            - file: {{ scriptlibdir }}

