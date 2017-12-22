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

cookbook_file "/tmp/mongodb/configure" do
  source "configure"
  mode 0755
end

search(:aws_opsworks_instance).each do |instance|
  status = instance['status']
  hostname = instance['hostname']

  Chef::Log.info("configuring instance #{hostname} with status #{status}")

  search(:aws_opsworks_app).each do |app|
    type = app['environment']['TYPE']
    next if type != 'server'

    username = app['environment']['MONGODB_USERNAME_ADMIN']
    password = app['environment']['MONGODB_PASSWORD_ADMIN']

    execute "configure" do
      user "root"
      cwd "/tmp/mongodb"
      command "./configure \"#{username}\" \"#{password}\" \"#{hostname}\" \"#{status}\""
      live_stream true
    end
  end
end