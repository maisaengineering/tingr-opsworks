#
# Cookbook Name:: opsworks-rails-mongoid
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

chef_gem "mongo" do
  version "1.10.1"
  action :install
end

chef_gem "bson" do
  version "2.2.3"
  action :install
end
#
# chef_gem "bson_ext" do
#   action :install
# end


require 'mongo'
require 'json'
require 'bson'
# require 'bson_ext'
