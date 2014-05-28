#
# Cookbook Name:: opsworks-commons
# Recipe:: env-vars
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

data_bag_item('aws', 'envs').each do |key, value|
  puts "key...#{key}"
  puts "value...#{value}"

  magic_shell_environment key do
    value value
  end
end
#
# ENV["AWS_KEY"] = "#{aws['aws_access_key_id']}"
# ENV["AWS_SECRET"] = "#{aws['aws_secret_access_key']}"
#
# magic_shell_environment 'AWS_KEY' do
#   value aws['aws_access_key_id']
# end
#
# magic_shell_environment 'AWS_SECRET' do
#   value aws['aws_secret_access_key']
# end
