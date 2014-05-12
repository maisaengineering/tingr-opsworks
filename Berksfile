site :opscode

cookbook 'build-essential'
cookbook 'java'
cookbook 'imagemagick'

cookbook 'opsworks-commons', '0.1.0', path: 'site-cookbooks/opsworks-commons'
cookbook 'opsworks-rails-mongoid', path: 'site-cookbooks/opsworks-rails-mongoid'
cookbook "mongodb", '~> 0.16.0', git: "https://github.com/edelight/chef-mongodb.git"

cookbook 'deploy', :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'deploy'
cookbook "dependencies", :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'dependencies'
cookbook "apache2", :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'apache2'
cookbook "mod_php5_apache2", :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'mod_php5_apache2'
cookbook "nginx", :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'nginx'
cookbook "ssh_users", :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'ssh_users'
cookbook "opsworks_agent_monit", :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'opsworks_agent_monit'
cookbook "passenger_apache2", :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'passenger_apache2'
cookbook "unicorn", :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'unicorn'
cookbook "opsworks_java", :git => 'https://github.com/aws/opsworks-cookbooks.git', :tag => 'release-chef-11.4', :rel => 'opsworks_java'
