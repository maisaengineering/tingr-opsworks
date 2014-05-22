#
# Cookbook Name:: opsworks-rails-mongoid
# Recipe:: mongo_mms_agent
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#
# include_recipe "mongodb::mongodb_org_repo"
# include_recipe "mongodb::default"
include_recipe "mongodb::mms-agent"
