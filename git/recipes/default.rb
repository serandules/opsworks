#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
scripts_path = "/tmp/git"

directory scripts_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

cookbook_file "/tmp/git/git" do
  source "git"
  mode 0755
end

execute "git" do
  user "root"
  cwd "/tmp/git"
  command "./git"
end