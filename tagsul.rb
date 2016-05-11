#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'yaml'

get '/:tag' do
  tag=params[:tag]
  output=params[:output]
  "Checking consul for all services tagged with #{tag}"

  services_with_tag=Array.new
  #Get all consul services
  services=JSON.parse(`curl -s consul.service.consul.rc.hms.harvard.edu/v1/catalog/services`)
  services.each do |service|
    if service[1].include?(tag)
      services_with_tag.push(service[0])
    end
  end
  #services_with_tag is now an array of service names w/ the tag provided. get all the ips/ports

  master_list=Array.new
  services_with_tag.each do |service|
    service_info=JSON.parse(`curl -s consul.service.consul.rc.hms.harvard.edu/v1/catalog/service/#{service}?tag=#{tag}`)
    #pp service_info
    nodes=Array.new
    ips=Array.new
    port=service_info[0]["ServicePort"]
    service_info.each do |i|
      ips.push(i["Address"])
      nodes.push(i["Node"])
    end
    service_obj={:name=>service, :port=>port, :nodes=>nodes, :ips=>ips}
    master_list.push(service_obj)
  end

  if output == 'json'
    master_list.to_json
  elsif output == 'yaml'
    master_list.to_yaml
  elsif output == nil or output == ""
    template = "
    <% master_list.each do |item| -%>
      <b>Service:</b> <%=item[:name] %> <br />
      <b>Port:</b> <%=item[:port] %> <br />
      <b>Nodes:</b> <%= item[:nodes] %> <br />
      <b>IPs:</b> <%= item[:ips] %> <br /><br /><br />
      <% end -%>
      "
      erb template, :locals => {:master_list => master_list}
  end
end
