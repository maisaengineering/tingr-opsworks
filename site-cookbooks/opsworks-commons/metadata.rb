name             'opsworks-commons'
maintainer       'Chandan Benjaram'
maintainer_email 'labs@maisasolutions.com'
license          'All rights reserved'
description      'Installs/Configures opsworks-commons'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apt'
depends 'build-essential'
depends 'java'
depends 'imagemagick'
depends 'wkhtmltopdf'

depends 'aws'
depends 'magic_shell'
