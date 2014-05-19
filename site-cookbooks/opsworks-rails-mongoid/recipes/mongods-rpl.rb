#
# Cookbook Name:: opsworks-rails-mongoid
# Recipe:: mongods-rpl
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

# include_recipe 'mongodb::mongo_gem'
#
# node.override['mongodb'] = {
#      "config" => {
#        "dbpath" => "/data/mongodb",
#        "logpath" => "/data/log/mongodb/mongodb.log",
#        "bind_ip" => "0.0.0.0",
#        "replSet" => "KLReplicaSet",
#        "port" => "27017"
#     },
#     "ruby_gems" => { :mongo => nil,:bson_ext => nil }
# }

node.override['mongodb']['config']['replSet'] = "KLReplicaSet"
# node.override['mongodb']['config']['dbpath'] = "/data/mongodb"
# node.override['mongodb']['config']['logpath'] = "/data/log/mongodb/mongodb.log"

include_recipe "opsworks-rails-mongoid::default"

include_recipe "mongodb::mongodb_org_repo"
include_recipe "mongodb::default"

old_replset_id=nil

replicaset_members=Chef::ResourceDefinitionList::OpsWorksORMHelper.replicaset_members(node)
replicaset_members.each_with_index { |member, index|
  Chef::Log.info("member.name=#{member['name']}")

  node_rs=Chef::ResourceDefinitionList::OpsWorksORMHelper.find_keyspace(member['name'], 27017)
  old_replset_id = node_rs unless node_rs.to_s.empty?
}

# old_replset_id=Chef::ResourceDefinitionList::OpsWorksORMHelper.find_keyspace(node['opsworks']['instance']['hostname'], 27017)
new_replset_id=node['mongodb']['config']['replSet']

Chef::Log.info("old replica set=#{old_replset_id}, new replica set=#{new_replset_id}")
mongods_rpl_filepath="/etc/mongods_rpl.js"
template mongods_rpl_filepath do
  source "mongods_rpl.js.erb"
  cookbook "opsworks-rails-mongoid"
  owner node[:mongodb][:user]
  group node[:mongodb][:group]
  mode 0644
  variables(
    :new_replset_id => new_replset_id,
    :old_replset_id => old_replset_id,
    :members => replicaset_members
  )
  action :create
  notifies :run, "execute[setup_mongods_rpl]", :immediately
end

execute "setup_mongods_rpl" do
  command "mongo < #{mongods_rpl_filepath}"
  action :run
end

file "/etc/mongodb.conf" do
  action :touch
  notifies :restart, "service[mongod]", :immediately
end
