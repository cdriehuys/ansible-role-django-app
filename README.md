cdriehuys.django-app
=========

Configure a django app using Gunicorn.

Requirements
------------

None.

Role Variables
--------------

In order for the role to run, the following variables **Must** be set.

```YAML
django_secret_key: your secret key here
```

The following are the variables used by the role and their defaults.

```YAML
apt_cache_time: 3600

# General App Settings
app_name: app           # Human readable name of the app
app_package: app        # Name of the app python package

# Version Control Settings
app_repo: ''                # The repo to pull source code from
app_repo_version: master    # The tag or branch to pull down

# Additional Packages
#
# These are additional packages required for the application to run
app_required_packages: []

# Django Project Configuration
django_project: /opt/{{ app_name }}     # Path to django project
django_app_dir: "{{ django_project }}/{{ app_package }}"
django_requirements: "{{ django_project }}/requirements.txt"

# Django Project Settings
django_log_file: /var/log/{{ app_name }}/django.log

django_admins: []
django_allowed_hosts: ["{{ inventory_hostname }}"]
django_databases: {}
django_debug: false
django_logging: {}
django_media_root: /var/www/{{ inventory_hostname }}/media
django_static_root: /var/www/{{ inventory_hostname }}/static

# Any additional settings can be defined in this dictionary
django_project_settings: {}


# A list of additional commands to run. Entries should be manage.py
# commands with their arguments like 'collectstatic --no-input'.
django_manage_commands: []

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
gunicorn_working_directory: "{{ django_app_dir }}"
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
