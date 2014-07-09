#
# General prod, dev, etc configuration:
#
# Oisin Mulvihill
# 2014-07-04
#

ipynotepad:
  server_name: www.ipynotepad
  proxy_uri: http://0.0.0.0:14521
  upstart_config: /etc/init/ipynotepad.conf
  service_name: ipynotepad
  run_as: vagrant
  command_line: ipython notebook --pylab inline --pprint --port 14521 --ip=* --notebook-dir=/home/vagrant/host_home
  log_file: /home/vagrant/ipynotepad.log
