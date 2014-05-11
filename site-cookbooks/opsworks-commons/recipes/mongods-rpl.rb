#
# Cookbook Name:: opsworks-commons
# Recipe:: mongods-rpl
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

# node.set['mongodb']['cluster_name'] = 'CB Test cluster'


include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::replicaset"

node.override['mongodb']['cluster_name'] = "CBTest 1"
node.set['mongodb']['cluster_name'] = 'CBTest 2'

mongodb_instance "mongodb" do
  config    "CBRepl Set"
  cluster_name  "CBTest 3"
end
