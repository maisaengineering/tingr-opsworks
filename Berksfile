site :opscode

cookbook 'build-essential'
cookbook 'java'
cookbook 'imagemagick'

cookbook 'opsworks-commons', '0.1.0', path: 'site-cookbooks/opsworks-commons'
cookbook 'opsworks-rails-mongoid', path: 'site-cookbooks/opsworks-rails-mongoid'
cookbook "mongodb", '~> 0.16.0', git: "https://github.com/edelight/chef-mongodb.git"

cookbook 'deploy', :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'deploy'
