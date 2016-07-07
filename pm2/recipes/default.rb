#
# Cookbook Name:: pm2
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

scripts_path = "/tmp/pm2"

directory scripts_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end
cookbook_file "/tmp/pm2/pm2" do
  source "pm2"
  mode 0755
end

execute "pm2" do
  user "root"
  cwd "/tmp/pm2"
  command "./pm2"
end