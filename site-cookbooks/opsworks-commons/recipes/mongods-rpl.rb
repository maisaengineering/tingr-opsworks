#
# Cookbook Name:: opsworks-commons
# Recipe:: mongods-rpl
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

# node.set['mongodb']['cluster_name'] = 'CB Test cluster'

node.set['mongodb']['cluster_name'] = "CB Rpl 786"
node.set['mongodb']['config']['rest'] = "true"
node.set['mongodb']['config']['bind_ip'] = "0.0.0.0"
node.set['mongodb']['config']['replSet'] = "CB Rpl 786"

include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::replicaset"



# node.set['mongodb'] = {
#     "cluster_name" => "CB Rpl 1",
#      "config" => {
#        "rest" => "false",
#        "bind_ip" => "0.0.0.0",
#        "replSet" => "CB Rpl 1"
#     }
# }
