#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file "/tmp/git" do
  source "git"
  mode 0755
end

execute "git" do
  user "root"
  cwd "/tmp"
  command "./git"
end