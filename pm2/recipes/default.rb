#
# Cookbook Name:: pm2
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file "/tmp/pm2" do
  source "pm2"
  mode 0755
end

execute "pm2" do
  user "root"
  cwd "/tmp"
  command "./pm2"
end