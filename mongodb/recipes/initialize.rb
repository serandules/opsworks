#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file "/tmp/mongodb/initialize" do
  source "initialize"
  mode 0755
end

execute "initialize" do
  user "root"
  cwd "/tmp/mongodb"
  command "./initialize"
end