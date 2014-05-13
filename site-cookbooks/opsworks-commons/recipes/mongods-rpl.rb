#
# Cookbook Name:: opsworks-commons
# Recipe:: mongods-rpl
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

# node.set['mongodb']['cluster_name'] = 'CB Test cluster'

# Chef::Resource::User.send(:include, Chef::ResourceDefinitionList::OpsWorksHelper)
include_recipe 'mongodb::mongo_gem'

# OpsWorks::InternalGems.internal_gem_package('rvm', :version => 'x.y.z')

node.override['mongodb'] = {
    "cluster_name" => "KLReplicaSet",
     "config" => {
       "rest" => "true",
       "bind_ip" => "0.0.0.0",
       "replSet" => "KLReplicaSet",
       "port" => "27017",
       "replication.replSetName" => "KLReplicaSet",
       "replication" => { "replSetName" => "KLReplicaSet"}
    },
    "ruby_gems" => { :mongo => nil,:bson_ext => nil }
}

Chef::Log.info('MongoDB solo installing...')
include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::default"
Chef::Log.info('...done')

# ::Chef::Recipe.send(:include, Chef::ResourceDefinitionList::MongoDB)
# Chef::Resource::User.send(:include, Chef::ResourceDefinitionList::MongoDB)


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


Chef::ResourceDefinitionList::MongoDB.configure_replicaset(node, replicaset_layer_slug_name, replicaset_members)

Chef::Log.info('...done')
# Chef::ResourceDefinitionList::MongoDB.configure_replicaset(new_resource.replicaset, replicaset_name, rs_nodes) unless new_resource.replicaset.nil?


# just-in-case config file drop
template "/etc/mongods_rpl.js" do
  source node['mongodb']['dbconfig_file_template']
  group node['mongodb']['root_group']
  owner 'root'
  mode 0644
  variables(
    :replSet => node['mongodb']['config'][:replSet],
    :replicaset_instances => replicaset_members
  )
  action :create_if_missing
end
