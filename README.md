[![Build Status](https://travis-ci.org/psyreactor/wordpress-cookbook.svg?branch=master)](https://travis-ci.org/psyreactor/wordpress-cookbook)
Wordpress Cookbook
===============

This cookbook install glpi from the source code.

####[Wordpress](https://wordpress.org/)
WordPress is a free and open source blogging tool and a content management system (CMS) based on PHP and MySQL, which runs on a web hosting service.Features include a plugin architecture and a template system. WordPress is used by more than 22.0% of the top 10 million websites as of August 2013.WordPress is the most popular blogging system in use on the Web, at more than 60 million websites.The most popular languages used are English, Spanish and Bahasa Indonesia.

Requirements
------------
#### Cookbooks:

- apache2 - https://github.com/onehealth-cookbooks/apache2
- mysql - https://github.com/opscode-cookbooks/mysql
- php - https://github.com/opscode-cookbooks/php
- database - https://github.com/opscode-cookbooks/database

The following platforms and versions are tested and supported using Opscode's test-kitchen.

- CentOS 5.8, 6.3

The following platform families are supported in the code, and are assumed to work based on the successful testing on CentOS.


- Red Hat (rhel)
- Fedora
- Amazon Linux

Recipes
-------
#### wordpress:default
##### Basic Config

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:version]</tt></td>
    <td>String</td>
    <td>version to install</td>
    <td><tt>3.9.1</tt></td>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:destination]</tt></td>
    <td>String</td>
    <td>Install Path for wordpress</td>
    <td><tt>/var/www/html</tt></td>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:db_name]</tt></td>
    <td>String</td>
    <td>Database name for wordpress</td>
    <td><tt>wordpress</tt></td>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:db_user]</tt></td>
    <td>String</td>
    <td>username for wordpress database</td>
    <td><tt>wordpress</tt></td>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:db_password]</tt></td>
    <td>String</td>
    <td>user password for wordpress database</td>
    <td><tt>password</tt></td>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:username]</tt></td>
    <td>String</td>
    <td>Admin user</td>
    <td><tt>waordpress</tt></td>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:password]</tt></td>
    <td>String</td>
    <td>Admin password</td>
    <td><tt>password</tt></td>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:title]</tt></td>
    <td>String</td>
    <td>Title for wordpress blog</td>
    <td><tt>Blog Wordpress</tt></td>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:mail]</tt></td>
    <td>String</td>
    <td>Admins mail</td>
    <td><tt>test@wordpress.com</tt></td>
  </tr>
  <tr>
    <td><tt>node[:wordpress][:domain]</tt></td>
    <td>String</td>
    <td>domain or ip for wordpress site</td>
    <td><tt>myblog.com</tt></td>
  </tr>
</table>
## Usage

### wordpress::default

Include `wordpress` in your node's `run_list`:

```json
"default_attributes": {
  "wordpress": {
    "username": "user",
    "password": "password,
    "mail': "test@mail.com",
    "vesion": "3.9.0",
    "domain": "mysite.com"
    }
  }
```


Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

[More details](https://github.com/psyreactor/wordpress-cookbook/blob/master/CONTRIBUTING.md)

License and Authors
-------------------
Authors:
Lucas Mariani (Psyreactor)
- [marianiluca@gmail.com](mailto:marianiluca@gmail.com)
- [https://github.com/psyreactor](https://github.com/psyreactor)