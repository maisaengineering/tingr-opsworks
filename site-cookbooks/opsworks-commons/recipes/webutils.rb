#
# Cookbook Name:: opsworks-commons
# Recipe:: webutils
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

include_recipe "imagemagick"
include_recipe "wkhtmltopdf"

Chef::Log.info('Setting ENV vars from databag items')

# aws = data_bag_item('aws', 'main')
# Chef::Log.info("Setting AWS_KEY ENV var...#{aws['aws_access_key_id']}")
# ruby_block "set-env-aws-key" do
#   block do
#     ENV["AWS_KEY"] = "#{aws['aws_access_key_id']}"
#   end
# end
#
# Chef::Log.info("Setting AWS_SECRET ENV var...#{aws['aws_access_key_id']}")
# ruby_block "set-env-aws-secret" do
#   block do
#     ENV["AWS_SECRET"] = "#{aws['aws_secret_access_key']}"
#   end
# end
