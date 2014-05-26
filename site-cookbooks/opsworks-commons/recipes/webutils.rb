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

Chef::Log.info("setting ENV vars...")
aws = data_bag_item('aws', 'main')
ENV["AWS_KEY"] = "#{aws['aws_access_key_id']}"
ENV["AWS_SECRET"] = "#{aws['aws_secret_access_key']}"
Chef::Log.info("...done => #{ENV["AWS_KEY"]}, #{ENV["AWS_SECRET"]}")

# ruby_block "set-env-aws-key" do
#   block do
#     ENV["AWS_KEY"] = "#{aws['aws_access_key_id']}"
#   end
# end
#
# ruby_block "set-env-aws-secret" do
#   block do
#     ENV["AWS_SECRET"] = "#{aws['aws_secret_access_key']}"
#   end
# end

Chef::Log.info("exporting ENV vars via magic shell")
magic_shell_environment 'AWS_KEY' do
  value aws['aws_access_key_id']
end

magic_shell_environment 'AWS_SECRET' do
  value aws['aws_secret_access_key']
end
