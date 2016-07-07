#
# Cookbook Name:: component
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
scripts_path = "/tmp/component"

directory scripts_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

cookbook_file "/tmp/component/component" do
  source "component"
  mode 0755
end

execute "component" do
  user "root"
  cwd "/tmp/component"
  command "./component"
end