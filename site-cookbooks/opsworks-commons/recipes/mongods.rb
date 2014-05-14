#
# Cookbook Name:: opsworks-commons
# Recipe:: mongods
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

node.override['mongodb'] = {
    "cluster_name" => "KLReplicaSet",
     "config" => {
       "dbpath" => "/data/mongodb",
       "logpath" => "/data/log/mongodb/mongodb.log",
       "rest" => "false",
       "bind_ip" => "0.0.0.0",
      #  "replSet" => "KLReplicaSet",
       "port" => "27017"
    },
    "ruby_gems" => { :mongo => nil,:bson_ext => nil }
}

include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::default"
