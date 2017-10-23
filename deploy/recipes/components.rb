#
# Cookbook Name:: deploy
# Recipe:: app
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'nodejs'
include_recipe 'component'

search(:aws_opsworks_app).each do |app|
  type = app['environment']['TYPE']
  next if type != 'component'
  deploy = app['environment']['DEPLOY']
  next if deploy != 'true'
  app_path = "/srv/#{app['shortname']}"
  scripts_path = '/opts/deploy'

  Chef::Log.info("********** deploying app '#{app['shortname']}' at '#{app_path}' **********")

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

  Chef::Log.info('********** setting up environment variables **********')
  template 'bootstrap' do
    source 'bootstrap.erb'
    path "#{app_path}/.bootstrap"
    mode '0644'
    owner 'root'
    group 'root'
    variables ({:environment => app['environment']})
  end

  Chef::Log.info('********** deploying components **********')
  cookbook_file '/opts/deploy/components' do
    source 'components'
    mode 0755
  end

  cookbook_file '/opts/deploy/components-uploader' do
    source 'components-uploader'
    mode 0755
  end

  cookbook_file '/opts/deploy/models' do
    source 'models'
    mode 0755
  end

  cookbook_file '/opts/deploy/release-create' do
    source 'release-create'
    mode 0755
  end

  execute 'components' do
    user 'root'
    cwd '/opts/deploy'
    command "./components #{app['shortname']} #{app_path} #{app['app_source']['url']} #{app['app_source']['revision']}"
    live_stream true
  end
end