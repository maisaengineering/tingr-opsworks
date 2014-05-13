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
       "port" => "27017"
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


# Chef::ResourceDefinitionList::OpsWorksHelper.configure_replicaset(node, replicaset_layer_slug_name, replicaset_members)

Chef::Log.info('calling mongodb helper...')
Chef::Log.info("node => #{node}")
Chef::Log.info("replicaset_layer_slug_name => #{replicaset_layer_slug_name}")
Chef::Log.info("replicaset_members => #{replicaset_members}")

Chef::ResourceDefinitionList::MongoDB.configure_replicaset(node, replicaset_layer_slug_name, replicaset_members)

Chef::Log.info('...done')
# Chef::ResourceDefinitionList::MongoDB.configure_replicaset(new_resource.replicaset, replicaset_name, rs_nodes) unless new_resource.replicaset.nil?

# 
#
# template "#{deploy[:deploy_to]}/shared/config/mongoid.yml" do
#   source "mongoid.yml.erb"
#   cookbook 'opsworks-rails-mongoid'
#   mode "0660"
#   group deploy[:group]
#   owner deploy[:user]
#
#   #replicaset_name = node['mongodb']['replicaset_name']
#   #replicaset_instances = node['opsworks']['layers'][replicaset_name]['instances'].keys.map{|name| "#{name}:27017"}
#
#   replicaset_instances = node["opsworks"]["layers"]["ds-mongo-rpl"]["instances"].keys.map{|server| "#{node["opsworks"]["layers"]["ds-mongo-rpl"]["instances"][server]["private_ip"]}:27017" }
#   variables(
#     :environment => deploy[:rails_env],
#     :replicaset_instances => replicaset_instances
#   )
#
#   notifies :run, "execute[restart Rails app #{application}]"
#
#   only_if do
#     File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
#   end
# end
