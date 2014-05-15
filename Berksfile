site :opscode

cookbook 'build-essential'
cookbook 'java'
cookbook 'imagemagick'
cookbook 'wkhtmltopdf', git: "https://github.com/bflad/chef-wkhtmltopdf.git"

cookbook 'opsworks-commons', '0.1.0', path: 'site-cookbooks/opsworks-commons'
cookbook 'opsworks-rails-mongoid', path: 'site-cookbooks/opsworks-rails-mongoid'
cookbook "mongodb", git: "https://github.com/edelight/chef-mongodb.git", ref: "87fa1133b986848e88d4cc24cea8b4804bf5e035"

cookbook "aws", '~> 2.2.0'
