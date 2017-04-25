cdriehuys.django-app
=========

Configure a django app using Gunicorn.

Requirements
------------

None.

Role Variables
--------------

The following are the variables used by the role and their defaults.

```YAML
apt_cache_time: 3600

# General App Settings
app_name: app           # Human readable name of the app
app_package: app        # Name of the app python package

# Version Control Settings
app_repo: ''                # The repo to pull source code from
app_repo_version: master    # The tag or branch to pull down

# Django Project Settings
django_project: /opt/{{ app_name }}     # Path to django project
django_requirements: "{{ django_project }}/requirements.txt"

# Gunicorn Settings
gunicorn_version: gunicorn     # Can specify another version like 'gunicorn >= 19.7'

gunicorn_user: gunicorn
gunicorn_group_primary: ''     # Name of gunicorn user's primary group
gunicorn_groups: []

gunicorn_service_conf: /etc/systemd/system/gunicorn.service
gunicorn_socket_conf: /etc/systemd/system/gunicorn.socket
gunicorn_tempfile_conf: /etc/tmpfiles.d/gunicorn.conf

gunicorn_bin: "{{ venv }}/bin/gunicorn"
gunicorn_socket: "/run/gunicon/socket"
gunicorn_socket_unix: "unix:{{ gunicorn_socket }}"
gunicorn_working_directory: "{{ django_project }}/{{ app_package }}"
gunicorn_wsgi_app: "{{ app_package }}.wsgi:application"

gunicorn_runtime_directory: gunicorn    # Relative to /run
gunicorn_pid: /run/{{ gunicorn_runtime_directory }}/pid
```

Dependencies
------------

Depends on the following roles:

```YAML
- cdriehuys.virtualenv
```

Example Playbook
----------------

To run the role, include it as follows.

    - hosts: all
      roles:
         - cdriehuys.django-app

License
-------

MIT

Author Information
------------------

Chathan Driehuys (cdriehuys@gmail.com)
