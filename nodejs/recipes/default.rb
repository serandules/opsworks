#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'git'

scripts_path = "/tmp/nodejs"

directory scripts_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

cookbook_file "/tmp/nodejs/nodejs" do
  source "nodejs"
  mode 0755
end

execute "nodejs" do
  user "root"
  cwd "/tmp/nodejs"
  command "./nodejs"
end