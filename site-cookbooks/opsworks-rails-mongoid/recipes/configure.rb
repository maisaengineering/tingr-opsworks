#
# Cookbook Name:: opsworks-rails-mongoid
# Recipe:: configure
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

# include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  execute "Restart Rails stack #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  node.default[:deploy][application][:database][:adapter] = OpsWorks::RailsConfiguration.determine_database_adapter(application, node[:deploy][application], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/shared/config/mongoid.yml" do
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

    # notifies :run, "execute[restart Rails app #{application}]", :immediately

    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

  template "#{deploy[:deploy_to]}/current/config/mongoid.yml" do
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

    notifies :restart, resources(:service => "unicorn_rails"), immediately
    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

end
