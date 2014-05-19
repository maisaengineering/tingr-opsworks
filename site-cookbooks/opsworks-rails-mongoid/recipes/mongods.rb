#
# Cookbook Name:: opsworks-rails-mongoid
# Recipe:: mongods
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mongodb::mongodb_org_repo"
include_recipe "mongodb::default"
