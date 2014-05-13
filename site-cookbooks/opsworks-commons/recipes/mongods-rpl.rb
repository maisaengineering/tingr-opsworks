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

node.override['mongodb'] = {
    "cluster_name" => "KLReplicaSet",
     "config" => {
       "rest" => "true",
       "bind_ip" => "0.0.0.0",
       "replSet" => "KLReplicaSet",
       "replication.replSetName" => "KLReplicaSet"
    }
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
Chef::Log.info("replicaset_layer_instances 1 = #{replicaset_layer_instances}")

replicaset_members= OpsWorksHelper.replicaset_members(node, replicaset_layer_instances)
Chef::Log.info("replicaset_members = #{replicaset_members}")


Chef::ResourceDefinitionList::OpsWorksHelper.configure_replicaset(node, replicaset_layer_slug_name, replicaset_members)


#MongoDB.configure_replicaset(new_resource.replicaset, replicaset_name, replicaset_layer_instances)
Chef::Log.info('calling...mongodb helper')
# Chef::ResourceDefinitionList::MongoDB.configure_replicaset(new_resource.replicaset, replicaset_name, rs_nodes) unless new_resource.replicaset.nil?
