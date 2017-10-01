#
# Cookbook Name:: deploy
# Recipe:: app
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'nodejs'
include_recipe 'pm2'

search(:aws_opsworks_app).each do |app|
  type = app['environment']['TYPE']
  next if type != 'server'
  deploy = app['environment']['DEPLOY']
  next if deploy != 'true'
  app_path = "/srv/#{app['shortname']}"
  scripts_path = "/tmp/apps"

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

  Chef::Log.info("deploying application")
  cookbook_file "/tmp/apps/app" do
    source "app"
    mode 0755
  end

  cookbook_file '/tmp/apps/models' do
    source 'models'
    mode 0755
  end

  cookbook_file '/tmp/apps/release-find' do
    source 'release-find'
    mode 0755
  end

  execute "app" do
    user "root"
    cwd "/tmp/apps"
    command "./app #{app['shortname']} #{app_path} #{app['app_source']['url']} #{app['app_source']['revision']}"
    environment app['environment']
    live_stream true
  end
end