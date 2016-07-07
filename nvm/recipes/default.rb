#
# Cookbook Name:: nvm
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

scripts_path = "/tmp/nvm"

directory scripts_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

cookbook_file "/tmp/nvm/nvm" do
  source "nvm"
  mode 0755
end

execute "nvm" do
  user "root"
  cwd "/tmp/nvm"
  command "./nvm"
end