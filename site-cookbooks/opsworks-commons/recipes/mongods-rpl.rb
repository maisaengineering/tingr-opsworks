#
# Cookbook Name:: opsworks-commons
# Recipe:: mongods-rpl
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mongodb::mongo_gem'
node.override['mongodb'] = {
    "cluster_name" => "KLReplicaSet",
     "config" => {
       "dbpath" => "/data/mongodb",
       "logpath" => "/data/log/mongodb/mongodb.log",
       "rest" => "false",
       "bind_ip" => "0.0.0.0",
       "replSet" => "KLReplicaSet",
       "port" => "27017"
    },
    "ruby_gems" => { :mongo => nil,:bson_ext => nil }
}

include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::default"
include_recipe "mongodb::mms-agent"

Chef::Log.info('reading replicaset_layer_slug_name...')
replicaset_layer_slug_name = node['opsworks']['instance']['layers'].first
Chef::Log.info("replicaset_layer_slug_name = #{replicaset_layer_slug_name}")

Chef::Log.info('reading replicaset_layer_instances...')
replicaset_layer_instances = node['opsworks']['layers'][replicaset_layer_slug_name]['instances']
Chef::Log.info("replicaset_layer_instances 2 = #{replicaset_layer_instances}")

replicaset_members= Chef::ResourceDefinitionList::OpsWorksHelper.replicaset_members(node)
Chef::Log.info("replicaset_members = #{replicaset_members}")

Chef::Log.info('calling mongodb helper...')
Chef::Log.info("node => #{node}")
Chef::Log.info("replicaset_layer_slug_name => #{replicaset_layer_slug_name}")
Chef::Log.info("replicaset_members => #{replicaset_members}")

Chef::Log.info("replicaset_members[n]...")
replicaset_members.each_with_index { |item, n| puts "#{replicaset_members[n]}" }

Chef::Log.info("replicaset_members[n]['fqdn']...")
replicaset_members.each_with_index { |item, n| puts "#{n}...#{replicaset_members[n]['fqdn']}" }

Chef::Log.info("replicaset_members[n]['mongodb']...")
replicaset_members.each_with_index { |item, n| puts "#{n}...#{replicaset_members[n]['mongodb']['config']['port']}" }


Chef::Log.info("replicaset_members[n]['mongodb']['config']...")
replicaset_members.each_with_index { |item, n| puts "#{n}...#{replicaset_members[n]['mongodb']['config']}" }

Chef::Log.info("replicaset_members[n]['mongodb']['config']['port']...")
replicaset_members.each_with_index { |item, n| puts "#{n}...#{replicaset_members[n]['mongodb']['config']['port']}" }

for index in 0 ... replicaset_members.size
  puts "replicaset_members[#{index}] = #{replicaset_members[index].inspect}"
  Chef::Log.info("replicaset_members[#{index}] = #{replicaset_members[index].inspect}")
  Chef::Log.info("replicaset_members[#{index}].name = #{replicaset_members[index].name}")
end

Chef::Log.info("node.name = #{node.name}")
#
# Chef::ResourceDefinitionList::MongoDB.configure_replicaset(node, replicaset_layer_slug_name, replicaset_members)
#
# Chef::Log.info('...done')
# Chef::ResourceDefinitionList::MongoDB.configure_replicaset(new_resource.replicaset, replicaset_name, rs_nodes) unless new_resource.replicaset.nil?

mongods_rpl_filepath = "/etc/mongods_rpl.js"

template mongods_rpl_filepath do
  source "mongods_rpl.js.erb"
  cookbook 'opsworks-commons'
  owner node[:mongodb][:user]
  group node[:mongodb][:group]
  mode 0644
  variables(
    :replSet => "KLReplicaSet",
    :replicaset_instances => replicaset_members
  )
  action :create
  notifies :run, 'execute[setup_mongods_rpl]', :immediately
end

execute "setup_mongods_rpl" do
  command "mongo < #{mongods_rpl_filepath}"
  action :nothing
end
