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

# Version Control Settings
app_repo: ''                # The repo to pull source code from
app_repo_version: master    # The tag or branch to pull down

# Django Project Settings
django_project: /opt/django-project     # Path to django project
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
