#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'nodejs'

scripts_path = "/tmp/mongodb"

directory scripts_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

cookbook_file "/tmp/mongodb/install" do
  source "install"
  mode 0755
end

cookbook_file "/tmp/mongodb/primary" do
  source "primary"
  mode 0755
end

cookbook_file '/tmp/mongodb/copy-s3-file' do
  source 'copy-s3-file'
  mode 0755
end

Chef::Log.info("copying mongod-bootstrap.conf")
template "mongod-bootstrap" do
  source "mongod-bootstrap.erb"
  path "/etc/mongod-bootstrap.conf"
  mode "0644"
  owner "root"
  group "root"
end

Chef::Log.info("copying mongod-custom.conf")
template "mongod" do
  source "mongod-custom.erb"
  path "/etc/mongod-custom.conf"
  mode "0644"
  owner "root"
  group "root"
end

search(:aws_opsworks_app).each do |app|
  type = app['environment']['TYPE']
  next if type != 'server'

  aws_key = app['environment']['AWS_KEY']
  aws_secret = app['environment']['AWS_SECRET']
  admin_username = app['environment']['MONGODB_USERNAME_ADMIN']
  admin_password = app['environment']['MONGODB_PASSWORD_ADMIN']
  apps_username = app['environment']['MONGODB_USERNAME_APPS']
  apps_password = app['environment']['MONGODB_PASSWORD_APPS']

  execute "primary" do
    user "root"
    cwd "/tmp/mongodb"
    command "./primary \"#{aws_key}\" \"#{aws_secret}\" \"#{admin_username}\" \"#{admin_password}\" \"#{apps_username}\" \"#{apps_password}\""
  end
end