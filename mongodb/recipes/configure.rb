#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

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
    next if type == 'server'

    username = app['environment']['MONGODB_USERNAME']
    password = app['environment']['MONGODB_PASSWORD']

    execute "configure" do
      user "root"
      cwd "/tmp/mongodb"
      command "./configure #{username} #{password} #{hostname} #{status}"
    end
  end
end