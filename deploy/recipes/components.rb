#
# Cookbook Name:: deploy
# Recipe:: app
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'nodejs'
include_recipe 'component'

app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}/current"
scripts_path = "/tmp/deploy"

directory app_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

directory scripts_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

Chef::Log.info("setting up environment variables")
template "bootstrap" do
  source "bootstrap.erb"
  path "#{app_path}/.bootstrap"
  mode "0644"
  owner "root"
  group "root"
  variables ({:environment => app['environment']})
end

Chef::Log.info("deploying components")
cookbook_file "/tmp/deploy/components" do
  source "components"
  mode 0755
end

cookbook_file "/tmp/deploy/components-uploader" do
  source "components-uploader"
  mode 0755
end

execute "components" do
  user "root"
  cwd "/tmp/deploy"
  command "./components #{app['shortname']} #{app_path} #{app['app_source']['url']} #{app['app_source']['revision']}"
end