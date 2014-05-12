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

# node.set['mongodb'] = {
#     "cluster_name" => "KLReplicaSet",
#      "config" => {
#        "rest" => "true",
#        "bind_ip" => "0.0.0.0",
#        "replSet" => "KLReplicaSet"
#     }
# }

node.set['mongodb']['cluster_name'] = "KLReplicaSet"
node.set['mongodb']['config']['rest'] = "true"
node.set['mongodb']['config']['bind_ip'] = "0.0.0.0"
node.set['mongodb']['config']['replSet'] = "KLReplicaSet"
