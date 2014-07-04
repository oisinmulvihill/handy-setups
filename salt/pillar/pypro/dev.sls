pp:
  admin:
    user: 'vagrant'
    group: 'vagrant'
    scriptlibdir: /home/vagrant/bin/lib

  # trailing slash is required.
  internal_pypi: ''

  dev_virtualenv: ipy
  src_dir: /home/vagrant/src
  workon_home: /home/vagrant/.virtualenvs

  # used by nginx as timeout when waiting on responses from backend services.
  read_timeout: 600