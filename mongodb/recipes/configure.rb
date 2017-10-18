#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

search(:aws_opsworks_instance).each do |instance|
  status = instance['status']
  hostname = instance['hostname']

  Chef::Log.info("configuring instance #{hostname} with status #{status}")

  cookbook_file "/tmp/mongodb/configure" do
    source "configure"
    mode 0755
  end

  execute "configure" do
    user "root"
    cwd "/tmp/mongodb"
    command "./configure #{hostname} #{status}"
  end
end