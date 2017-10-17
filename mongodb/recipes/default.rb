#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

scripts_path = "/tmp/mongodb"

directory scripts_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

Chef::Log.info("copying mongod.conf")
template "mongod" do
  source "mongod.erb"
  path "/etc/mongod-tmp.conf"
  mode "0644"
  owner "root"
  group "root"
end

cookbook_file "/tmp/mongodb/default" do
  source "default"
  mode 0755
end

execute "default" do
  user "root"
  cwd "/tmp/mongodb"
  command "./default"
end