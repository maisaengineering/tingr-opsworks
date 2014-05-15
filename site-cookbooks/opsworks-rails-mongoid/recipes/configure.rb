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
  aws = data_bag_item('aws', 'main')
  deploy = node[:deploy][application]

  ruby_block "Carrierwave conf replace AWS_KEY" do
    block do
      cfg = Chef::Util::FileEdit.new("#{deploy[:deploy_to]}/current/config/initializers/carrierwave.rb")
      cfg.search_file_replace(/ENV\[\'AWS_KEY\'\]/i, "#{aws['aws_access_key_id']}")
      cfg.write_file
    end
    notifies :run, "execute[unicorn_restart]"
    only_if do
      ::File.read("#{deploy[:deploy_to]}/current/config/initializers/carrierwave.rb").include?("ENV['AWS_KEY']")
    end
  end

  ruby_block "Carrierwave conf replace AWS_SECRET" do
    block do
      cfg = Chef::Util::FileEdit.new("#{deploy[:deploy_to]}/current/config/initializers/carrierwave.rb")
      cfg.search_file_replace(/ENV\[\'AWS_SECRET\'\]/i, "#{aws['aws_secret_access_key']}")
      cfg.write_file
    end
    notifies :run, "execute[unicorn_restart]"
    only_if do
      ::File.read("#{deploy[:deploy_to]}/current/config/initializers/carrierwave.rb").include?("ENV['AWS_SECRET']")
    end
  end

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
    notifies :run, "execute[unicorn_restart]"
    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/config/config/")
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
    notifies :run, "execute[unicorn_restart]"
    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

  execute "unicorn_restart" do
    command "#{deploy[:deploy_to]}/shared/scripts/unicorn restart"
    action :nothing
  end

  #
  # execute "Restart Rails stack #{application}" do
  #   cwd deploy[:current_path]
  #   command node[:opsworks][:rails_stack][:restart_command]
  #   action :nothing
  # end

end
