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
  scripts_path = "/opts/deploy"

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
  cookbook_file "/opts/deploy/clients" do
    source "clients"
    mode 0755
  end

  cookbook_file '/opts/deploy/models' do
    source 'models'
    mode 0755
  end

  cookbook_file '/opts/deploy/release-find' do
    source 'release-find'
    mode 0755
  end

  execute "clients" do
    user "root"
    cwd "/opts/deploy"
    command "./clients #{app['shortname']} #{app_path} #{app['app_source']['url']} #{app['app_source']['revision']}"
    environment app['environment']
    live_stream true
  end
end