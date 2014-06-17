name             "wordpress"
maintainer       "Mariani Lucas"
maintainer_email "marianilucas@gmail.com"
license          "Apache 2.0"
description      "Installs worpress"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue "0.1.0"

depends 'apache2'
depends 'mysql'
depends 'php'
depends 'database'