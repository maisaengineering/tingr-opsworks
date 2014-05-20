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
  Chef::Log.info("deploy...#{deploy}")

  rails_env = deploy[:rails_env]
  Chef::Log.info("deploy...#{rails_env}")

  current_path = deploy[:current_path]
  Chef::Log.info("deploy...#{current_path}")

  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")

  execute 'rake assets:precompile' do
   cwd current_path
   user 'deploy'
   command 'bundle exec rake assets:precompile'
   environment 'RAILS_ENV' => rails_env
  end

end
