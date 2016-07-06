#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'git'

cookbook_file "/tmp/nodejs" do
  source "nodejs"
  mode 0755
end

execute "nodejs" do
  user "root"
  cwd "/tmp"
  command "./nodejs"
end