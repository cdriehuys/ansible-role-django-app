# cdriehuys.django-app

[![Travis](https://img.shields.io/travis/cdriehuys/ansible-role-django-app.svg)](https://travis-ci.org/cdriehuys/ansible-role-django-app)

Ansible role to serve a Django application with gunicorn.


**Note:** If this role does not have a capability that you would like, feel free to [open an issue](https://github.com/cdriehuys/ansible-role-django-app/issues/new) so we can discuss it more.


## Table of Contents

* [Requirements](#requirements)
* [Role Variables](#role-variables)
    * [Required](#required)
    * [Commonly Used](#commonly-used)
    * [Shared](#shared)
    * [Django](#django)
    * [Gunicorn](#gunicorn)
* [Dependencies](#dependencies)
* [Example Playbook](#example-playbook)
* [License](#license)
* [Author Information](#author-information)


## Requirements

In order to make use of the settings uploaded by the role, you must import the local settings file in your production settings file. For example:

```python
# production_settings.py

DEBUG = False
ALLOWED_HOSTS = ['...']


try:
    from app_package.local_settings import *
except ImportError:
    pass
```

We also make some assumptions about the structure of your project. While these assumptions can be overridden by setting the appropriate variables, it would be easiest if your project is structured in the following manner:

```
app-name
├── app_package
│   ├── app_package
│   │   └── settings.py
│   ├── other_apps
│   └── are_here
├── LICENSE
└── requirements.txt
```


## Role Variables

Here is a list of the variables used by the role. Every variable except for the ones in the [Required Variables](#required) have their default value listed.

### Required

The following variables **must** be set in order for the role to run.

```YAML
# Path to the git repository where your code is stored
app_repo: https://your-repo-host/user/repo-name

# Secret key to use for Django
django_secret_key: your secret key here
```

### Commonly Used

These settings are used to control import information about your project. They are also the variables that are most commonly overridden since they vary from project to project.

```YAML
# The human readable name of your application. Your project will be
# cloned into a directory with this name.
app_name: app

# The package name is the name of your actual python module. This is the
# name you provided to 'django-admin startproject <app_package>'.
app_package: app

# The version of your application to deploy. This can be a specific
# commit hash, a branch name, or a tag name.
app_repo_version: master

# This is a list of system packages that must be installed in order for
# your project to run.
app_required_packages: []

# The Django settings file to use.
django_settings_module: "{{ app_package }}.settings"
```

### Shared

These variables are used by multiple roles to control common behavior.

```YAML
# The duration that the apt cache is valid for in seconds
apt_cache_time: 3600
```

### Django

These variables are used to configure Django's behavior.

```YAML
# Database configuration. This should be a dictionary containing the
# same attributes that Django expects (ENGINE, HOST, USER, etc.).
django_databases: {}

# A list of Django management commands to run during deployment. This
# should a full command such as 'collectstatic --noinput'
django_manage_commands: []

# Any additional Django settings that you want to configure can be
# provided as a dictionary. Make sure to double quote your values so
# they are templated correctly.
django_project_settings: {}


# Path to root of Django project
django_project: /opt/{{ app_name }}

# Path to Django application (the folder with 'manage.py')
django_app_dir: "{{ django_project }}/{{ app_package }}"

# Path where local settings file will be uploaded
django_local_settings: "{{ django_app_dir }}/{{ app_package }}/local_settings.py"

# Path to requirements.txt file
django_requirements: "{{ django_project }}/requirements.txt"

# Path to Django log file. Nothing will be written here unless you
# override the 'django_logging' setting.
django_log_file: /var/log/{{ app_name }}/django.log

# Django logging configuration. This should be a YAML dictionary with
# the same attributes that Python's logging module expects.
django_logging: {}

# Paths where static files are uploaded
django_media_root: /var/www/{{ inventory_hostname }}/media
django_static_root: /var/www/{{ inventory_hostname }}/static
```

### Gunicorn

The following variables control the configuration of the Gunicorn server that is responsible for serving the Django application.

```YAML
# Specify which version of gunicorn to install. This can be any version
# specifier that pip accepts.
gunicorn_version: gunicorn

# The user created to run gunicorn.
gunicorn_user: gunicorn


# The path that the gunicorn systemd service unit is uploaded to.
gunicorn_service_conf: /etc/systemd/system/gunicorn.service

# The path that the gunicorn socket configuration is uploaded to.
gunicorn_socket_conf: /etc/systemd/system/gunicorn.socket

# The path that the gunicorn tempfile configuration is uploaded to.
gunicorn_tempfile_conf: /etc/tmpfiles.d/gunicorn.conf


# Directory relative to '/run' to store runtime information in
gunicorn_runtime_directory: gunicorn

# Path to store Gunicorn's PID file at
gunicorn_pid: /run/{{ gunicorn_runtime_directory }}/pid

# Path to the socket used to communicate with gunicorn
gunicorn_socket: /run/{{ gunicorn_runtime_directory }}/socket

# Unix path to the gunicorn socket
gunicorn_socket_unix: "unix:{{ gunicorn_socket }}"


# Path to the gunicorn binary
gunicorn_bin: "{{ venv }}/bin/gunicorn"

# Directory that gunicorn is run from
gunicorn_working_directory: "{{ django_app_dir }}"

# Path to the WSGI application to run, relative to
# 'gunicorn_working_directory'.
gunicorn_wsgi_app: "{{ app_package }}.wsgi:application"
```


## Dependencies

Depends on the following roles:

```YAML
- cdriehuys.virtualenv
```


## Example Playbook

To run the role, include it as follows.

```YAML
- hosts: all
  roles:
     - cdriehuys.django-app
```


## License

MIT


## Author Information

Chathan Driehuys (cdriehuys@gmail.com)
