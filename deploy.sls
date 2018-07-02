{%- from 'tomcat/map.jinja' import tomcat with context %}

add_container_user:
  user.present:
    - name: {{ tomcat.install.container_user }}
    - createhome: False
    - shell: /bin/false
    - system: True  

install_support_software:
  pkg.installed:
    - pkgs:
      {%- for spkg in tomcat.install.support_packages %}
      - {{ spkg }}
      {%- endfor %}

retrieve_tomcat:
  archive.extracted:
    - name: {{ tomcat.install.directory }}
    - source: http://apache.mirrors.lucidnetworks.net/tomcat/tomcat-{{ tomcat.install.major }}/v{{ tomcat.install.version }}/bin/apache-tomcat-{{ tomcat.install.version }}.tar.gz
    - user: root
    - group: root
    - skip_verify: True

link_to_current_deployment:
  file.symlink:
    - name: {{ tomcat.install.directory }}/tomcat
    - target: {{ tomcat.install.directory }}/apache-tomcat-{{ tomcat.install.version }}
    - user: root
    - group: root

correct_permissions:
  file.directory:
    - name: {{ tomcat.install.directory }}/apache-tomcat-{{ tomcat.install.version }}
    - user: {{ tomcat.install.container_user }}
    - group: {{ tomcat.install.container_user }}
    - recurse:
      - user
      - group

{%- if grains.get('init') == "systemd" %}
/etc/systemd/system/tomcat.service:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://tomcat/files/tomcat.service
    - template: jinja
    - context:
      config: {{ tomcat.install }}
    
reload_systemd:
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: /etc/systemd/system/tomcat.service 
{%- endif %}
