#
# Cookbook Name:: opsworks-rails-mongoid
# Recipe:: configure
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute

# node[:deploy].each do |application, deploy|
#
#   Chef::Log.info("rails_env... #{rails_env}")
#
#   # execute "unicorn_restart" do
#   #   command "#{deploy[:deploy_to]}/shared/scripts/unicorn restart"
#   #   action :nothing
#   # end
#
# end
#
# deploy_revision "/deploy/dir/" do
#
#   before_migrate do
#     Chef::Log.info("inside before_migrate...before_migrate")
#
#   end
# end



node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  rails_env = deploy[:rails_env]
  replicaset_instances = node["opsworks"]["layers"]["ds-mongo-rpl"]["instances"].keys.map{|server| "#{node["opsworks"]["layers"]["ds-mongo-rpl"]["instances"][server]["private_ip"]}:27017" }
  Chef::Log.info("deploy... #{deploy}")
  Chef::Log.info("deploy_to... #{deploy[:deploy_to]}")

  Chef::Log.info("rails_env... #{rails_env}")
  Chef::Log.info("replicaset_instances... #{replicaset_instances}")

  Chef::Log.info("configuring #{deploy[:deploy_to]}/config/mongoid.yml")
  before_migrate do
    Chef::Log.info("executing before migrate inside")
    template "#{deploy[:deploy_to]}/shared/config/mongoid.yml" do
      source "mongoid.yml.erb"
      cookbook 'opsworks-rails-mongoid'
      mode "0660"
      group deploy[:group]
      owner deploy[:user]
      variables(
        :environment => rails_env,
        :replicaset_instances => replicaset_instances
      )
    end
  end


  Chef::Log.info("precompiling assets for #{rails_env}...")
  execute "rake assets:precompile" do
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec rake assets:precompile"
    environment "RAILS_ENV" => rails_env
  end

  # execute "unicorn_restart" do
  #   command "#{deploy[:deploy_to]}/shared/scripts/unicorn restart"
  #   action :nothing
  # end

end
