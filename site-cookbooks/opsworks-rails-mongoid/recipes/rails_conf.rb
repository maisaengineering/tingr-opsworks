#
# Cookbook Name:: opsworks-rails-mongoid
# Recipe:: rails_conf
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  rails_env = deploy[:rails_env]

  current_path = deploy[:current_path]
  execute 'rake assets:precompile' do
   cwd current_path
   user 'deploy'
   command 'bundle exec rake assets:precompile'
   environment 'RAILS_ENV' => rails_env
  end

end
