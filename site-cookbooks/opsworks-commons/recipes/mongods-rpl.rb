#
# Cookbook Name:: opsworks-commons
# Recipe:: mongods-rpl
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

# include_recipe 'mongodb::mongo_gem'

node.override['mongodb']['config']['replSet'] = "KLReplicaSet"
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

include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::default"

replicaset_members= Chef::ResourceDefinitionList::OpsWorksHelper.replicaset_members(node)
replicaset_members.each_with_index { |item, n| Chef::Log.info("#{n}...#{item[n].inspect}") }

old_replset_id=`mongo --eval "printjson(rs.status())" | grep "set" | cut -d'"' -f4`
Chef::Log.info("old_replset_id=#{old_replset_id}")

new_replset_id=node['mongodb']['config']['replSet']
Chef::Log.info("new_replset_id=#{new_replset_id}")

mongods_rpl_filepath = "/etc/mongods_rpl.js"
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
end

execute "setup_mongods_rpl" do
  command "mongo < #{mongods_rpl_filepath}"
  action :nothing
end
