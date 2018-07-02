{%- from 'tomcat/map.jinja' import tomcat with context %}

# Manage conf/
{{ tomcat.install.directory}}/tomcat/conf/server.xml:
  file.managed:
    - owner: {{ tomcat.install.container_user }}
    - group: {{ tomcat.install.container_user }} 
    - mode: 640
    - source: salt://tomcat/files/server.xml
    - template: jinja
    - context: 
      config: {{ tomcat.config }}

{{ tomcat.install.directory}}/tomcat/conf/tomcat.conf:
  file.managed:
    - owner: {{ tomcat.install.container_user }}
    - group: {{ tomcat.install.container_user }} 
    - mode: 640
    - source: salt://tomcat/files/tomcat.conf
    - template: jinja
    - context: 
      config: {{ tomcat.config }}
