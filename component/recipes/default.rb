#
# Cookbook Name:: component
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file "/tmp/component" do
  source "component"
  mode 0755
end

execute "component" do
  user "root"
  cwd "/tmp"
  command "./component"
end