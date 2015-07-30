#
# Cookbook Name:: opsworks-commons
# Recipe:: default
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'build-essential::default'
include_recipe 'java'

include_recipe "imagemagick"
# include_recipe "wkhtmltopdf"
