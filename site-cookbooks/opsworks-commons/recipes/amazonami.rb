#
# Cookbook Name:: opsworks-commons
# Recipe:: amazonami
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

packages = [
  "libcurl",
  "libcurl-devel",
]

packages.each do |p|
  package p do
    action :install
  end
end
