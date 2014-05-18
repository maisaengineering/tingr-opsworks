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
node.override['mongodb']['config']['dbpath'] = "/data/mongodb"
node.override['mongodb']['config']['logpath'] = "/data/log/mongodb/mongodb.log"

include_recipe "opsworks-rails-mongoid::default"

include_recipe "mongodb::mongodb_org_repo"
include_recipe "mongodb::default"

replicaset_members=Chef::ResourceDefinitionList::OpsWorksORMHelper.replicaset_members(node)

Chef::Log.info("replicaset_members=#{replicaset_members}")
puts "RUBY replicaset_members=#{replicaset_members.inspect}"

replicaset_members.each_with_index { |item, n| Chef::Log.info("#{n}...#{item.inspect}") }

old_replset_id=Chef::ResourceDefinitionList::OpsWorksORMHelper.grab_keyspace()

# old_replset_id=`mongo --eval "printjson(rs.status())" | egrep -i '^\s+"set"' | cut -d'"' -f4`

Chef::Log.info("old_replset_id=#{old_replset_id}")
new_replset_id=node['mongodb']['config']['replSet']

Chef::Log.info("new_replset_id=#{new_replset_id}")

Chef::Log.info("replicaset_members=#{replicaset_members.inspect}")

mongods_rpl_filepath="/etc/mongods_rpl.js"
template mongods_rpl_filepath do
  source "mongods_rpl.js.erb"
  cookbook 'opsworks-commons'
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
