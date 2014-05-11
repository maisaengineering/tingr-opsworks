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


mongodb_instance "mongodb" do
  # dbpath node['application']['cbdb_path']
  replSet   "CBRepl Set"
  cluster_name  "CB Test Cluster"
end
