#
# Cookbook Name:: opsworks-rails-mongoid
# Recipe:: mongods-rpl
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

node.override['mongodb']['config']['replSet'] = node[:mongodb][:replicaset_id]

include_recipe "opsworks-rails-mongoid::default"
include_recipe "opsworks-rails-mongoid::mongods"

Chef::Log.info("new replica set=#{node[:mongodb][:replicaset_id]}")

old_replset_id=nil
replicaset_members=Chef::ResourceDefinitionList::OpsWorksORMHelper.replicaset_members(node)
replicaset_members.each_with_index { |member, index|
  node_rs=Chef::ResourceDefinitionList::OpsWorksORMHelper.find_keyspace(member['name'], 27017)
  next if node_rs.to_s.empty?
  if !old_replset_id.to_s.empty? and !old_replset_id.to_s.eql?(node_rs.to_s)
    # allocates random, time.now, replica set id for force reconfig
    old_replset_id = Time.now.to_i
    break
  else
    old_replset_id = node_rs
  end
}

new_replset_id=node[:mongodb][:replicaset_id]
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

dbconfig_file=node['mongodb']['dbconfig_file']
Chef::Log.info("dbconfig_file=#{dbconfig_file}")

file dbconfig_file do
  action :touch
  notifies :restart, "service[mongod]", :immediately
end
