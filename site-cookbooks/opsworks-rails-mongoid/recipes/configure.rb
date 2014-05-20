#
# Cookbook Name:: opsworks-rails-mongoid
# Recipe:: configure
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute


node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  template "#{deploy[:current_path]}/config/mongoid.yml" do
    source "mongoid.yml.erb"
    cookbook 'opsworks-rails-mongoid'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    replicaset_instances = node["opsworks"]["layers"]["ds-mongo-rpl"]["instances"].keys.map{|server| "#{node["opsworks"]["layers"]["ds-mongo-rpl"]["instances"][server]["private_ip"]}:27017" }
    variables(
      :environment => deploy[:rails_env],
      :replicaset_instances => replicaset_instances
    )
    notifies :run, "execute[unicorn_restart]"
  end

  execute "unicorn_restart" do
    command "#{deploy[:deploy_to]}/shared/scripts/unicorn restart"
    action :nothing
  end

end
