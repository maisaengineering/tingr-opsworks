source "https://api.berkshelf.com"

cookbook 'build-essential'
cookbook 'java'
cookbook 'imagemagick'
cookbook 'wkhtmltopdf', git: "https://github.com/bflad/chef-wkhtmltopdf.git"
cookbook "yum", git: "https://github.com/opscode-cookbooks/yum.git", tag: "v3.2.0"

cookbook "mongodb", git: "https://github.com/edelight/chef-mongodb.git", ref: "87fa1133b986848e88d4cc24cea8b4804bf5e035"
cookbook "aws", '~> 2.2.0'

cookbook "opsworks-commons", git: "https://github.com/maisaengineering/opsworks.git", rel: "site-cookbooks/opsworks-commons"
cookbook "opsworks-rails-mongoid", git: "https://github.com/maisaengineering/opsworks.git", rel: "site-cookbooks/opsworks-rails-mongoid"
