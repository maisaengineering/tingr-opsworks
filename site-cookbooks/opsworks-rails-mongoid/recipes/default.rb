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

require 'mongo'
