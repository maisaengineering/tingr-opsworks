#
# Cookbook Name:: opsworks-commons
# Recipe:: ds-ebs-volutils
#
# Copyright (C) 2014 Chandan Benjaram
#
# All rights reserved - Do Not Redistribute
#

Chef::Log.info('CB reading aws databag...')
# get AWS credentials from the aws data_bag
aws = data_bag_item('aws', 'main')

Chef::Log.info("CB aws = #{aws}")
Chef::Log.info("CB aws[aws_access_key_id] = #{aws['aws_access_key_id']}")
Chef::Log.info("CB aws[aws_secret_access_key] = #{aws['aws_secret_access_key']}")
Chef::Log.info("CB node[opsworks-commons][ebs][raid] = #{node['opsworks-commons']['ebs']['raid']}")
Chef::Log.info("CB node[opsworks-commons][ebs][size] = #{node["opsworks-commons"]["ebs"]["size"]}")

include_recipe 'aws'

directory '/var/data' do
  mode '0755'
  action :create
end

if node["opsworks-commons"]["ebs"]["raid"]
  Chef::Log.info("RAID processing...")

  # use the aws_ebs_raid provider to create and mount a RAID volume. This provider
  # basically does everything for us, so there's nothing more to do!
  aws_ebs_raid 'data_volume_raid' do
    mount_point '/var/data'
    disk_count 2
    disk_size node["opsworks-commons"]["ebs"]["size"]
    level 10
    filesystem 'ext4'
    action :auto_attach
  end
else
  Chef::Log.info("Single volume processing...")
  # create a single EBS volume
  # get an unused device ID for the EBS volume
  devices = Dir.glob('/dev/xvd?')
  devices = ['/dev/xvdf'] if devices.empty?
  devid = devices.sort.last[-1,1].succ

  # save the device used for data_volume on this node -- this volume will now always
  # be attached to this device
  node.set_unless["aws"]["ebs_volume"]["data_volume"]["device"] = "/dev/xvd#{devid}"
  device_id = node["aws"]["ebs_volume"]["data_volume"]["device"]
  Chef::Log.info("device_id=#{device_id}")

  # create and attach the volume to the device determined above
  aws_ebs_volume 'data_volume' do
    aws_access_key aws['aws_access_key_id']
    aws_secret_access_key aws['aws_secret_access_key']
    device device_id.gsub('xvd', 'sd') # aws uses sdx instead of xvdx
    size 50
    volume_type  "io1"
    piops  1000
    timeout  300 # in seconds
    action [ :create, :attach ]
  end

  # wait for the drive to attach, before making a filesystem
  ruby_block "sleeping_data_volume" do
    block do
      loop do
        if File.blockdev?(device_id)
          break
        else
          Chef::Log.info("device #{device_id} not ready - sleeping 10s")
          sleep 10
        end
      end
    end
    action :nothing
  end

  mount_point = '/var/data'

  # create a filesystem
  execute 'mkfs' do
    command "mkfs -t ext4 #{device_id}"
    # only if it's not mounted already
    not_if "grep -qs #{mount_point} /proc/mounts"
  end

  # now we can enable and mount it and we're done!
  mount "#{mount_point}" do
    device device_id
    fstype 'ext4'
    options 'noatime,nobootwait'
    action [:enable, :mount]
  end
end
