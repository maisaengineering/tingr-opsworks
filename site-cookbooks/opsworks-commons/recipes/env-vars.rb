#
# Cookbook Name:: opsworks-commons
# Recipe:: env-vars
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

envs = data_bag_item('aws', 'envs')
unless envs.to_s.nil?
  envs.each do |k, v|
    magic_shell_environment k do
      value v
    end
  end
end
#
ENV["AWS_KEY"] = "#{envs['aws_access_key_id']}"
ENV["AWS_SECRET"] = "#{envs['aws_secret_access_key']}"
ENV["GMAIL_PASSWORD"] = "#{envs['GMAIL_PASSWORD']}"
#
# magic_shell_environment 'AWS_KEY' do
#   value aws['aws_access_key_id']
# end
#
# magic_shell_environment 'AWS_SECRET' do
#   value aws['aws_secret_access_key']
# end
