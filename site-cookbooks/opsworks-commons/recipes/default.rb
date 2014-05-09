#
# Cookbook Name:: opsworks-commons
# Recipe:: default
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt::default'
include_recipe 'build-essential::default'
include_recipe 'java'

execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
  only_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

packages = [
  "libcurl3",
  "libcurl3-gnutls",
  "libcurl4-openssl-dev"
]

packages.each do |p|
  package p do
    action :install
  end
end
