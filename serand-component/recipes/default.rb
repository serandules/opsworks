#
# Cookbook Name:: serand-component
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'build-essential::default'

app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}"

package "git" do
  # workaround for:
  # WARNING: The following packages cannot be authenticated!
  # liberror-perl
  # STDERR: E: There are problems and -y was used without --force-yes
  options "--force-yes" if node["platform"] == "ubuntu" && node["platform_version"] == "14.04"
end

application app_path do
  git app_path do
    repository app["app_source"]["url"]
    revision app["app_source"]["revision"]
  end
end

bash 'build-components' do
  cwd ::File.dirname(app_path)
  code <<-EOH
    npm install -g component@1.1.0
    component build
    ls -alh build
    EOH
end
