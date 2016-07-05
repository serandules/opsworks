#
# Cookbook Name:: nvm
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file "/tmp/nvm" do
  source "nvm"
  mode 0755
end

execute "touchfile" do
  user "root"
  cwd "/tmp"
  command "./nvm"
end