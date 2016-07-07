#
# Cookbook Name:: deploy
# Recipe:: app
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'nodejs'
include_recipe 'pm2'

app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}/current"

Chef::Log.info("setting up environment variables")
template "bootstrap" do
  source "bootstrap.erb"
  path "#{app_path}/.bootstrap"
  mode "0644"
  owner "root"
  group "root"
  variables ({:environment => app['environment']})
end

Chef::Log.info("deploying application")
cookbook_file "/tmp/deploy/app" do
  source "app"
  mode 0755
end

execute "app" do
  user "root"
  cwd "/tmp/deploy"
  command "./app #{app['shortname']} #{app_path} #{app['app_source']['url']} #{app['app_source']['revision']}"
end