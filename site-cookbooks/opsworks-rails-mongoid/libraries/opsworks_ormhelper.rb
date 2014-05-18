require 'chef/node'

class Chef::ResourceDefinitionList::OpsWorksORMHelper

  # true if we're on opsworks, false otherwise
  def self.opsworks?(node)
    node['opsworks'] != nil
  end

  # return Chef Nodes for this replicaset / layer
  def self.replicaset_members_with_mongo_conf(node)
    members = []
    # FIXME -> this is bad, we're assuming replicaset instances use a single layer
    node_layer = node['opsworks']['instance']['layers'].first
    instances = node['opsworks']['layers'][replicaset_layer_slug_name]['instances']
    instances.each do |name, instance|
      if instance['status'] == 'online'
        member = Chef::Node.new
        new_name = "#{name}.localdomain"
        member.name(name)
        member.default['fqdn'] = instance['private_dns_name']
        member.default['ipaddress'] = instance['private_ip']
        member.default['hostname'] = new_name
        mongodb_attributes = {
          # here we could support a map of instances to custom replicaset options in the custom json
          'port' => node['mongodb']['config']['port'],
          'replica_arbiter_only' => false,
          # 'replica_build_indexes' => false,
          'replica_hidden' => false,
          'replica_slave_delay' => 0,
          'replica_priority' => instance['private_ip'].gsub(/^.*\.(?=\d+)/, '').to_i,
          'replica_tags' => {}, # to_hash is called on this
          'replica_votes' => 1,
          'config' => {
            'port' => node['mongodb']['config']['port'],
            'replica_arbiter_only' => false,
            # 'replica_build_indexes' => true,
            'replica_hidden' => false,
            'replica_slave_delay' => 0,
            'replica_priority' => instance['private_ip'].gsub(/^.*\.(?=\d+)/, '').to_i,
            'replica_tags' => {}, # to_hash is called on this
            'replica_votes' => 1
          }
        }
        member.default['mongodb'] = mongodb_attributes
        members << member
      end
    end
    members
  end

  def self.replicaset_members(node)
    members = []
    hidden_members = []
    layers = [ node['opsworks']['instance']['layers'].first ]

    # from mongodb overrides
    unless node[:mongodb].nil?
      layers |= node[:mongodb][:layers].split(",") unless node[:mongodb][:layers].nil?
      hidden_members |= node[:mongodb][:hidden].split(",") unless node[:mongodb][:hidden].nil?
    end


    Chef::Log.info("layers=#{layers.inspect}")

    Chef::Log.info("hidden_members=#{hidden_members.inspect}")

    layers.each do |layer|
      Chef::Log.info("layer=#{layer}")
      instances = node['opsworks']['layers'][layer]['instances']
      instances.each do |name, instance|
        Chef::Log.info("name=#{name}, instance=#{instance}")
        if instance['status'] == 'online'
          Chef::Log.info("online instance=#{instance}")
          member = Chef::Node.new
          new_name = "#{name}.localdomain"
          member.name(name)
          member.default['name'] = name
          member.default['fqdn'] = instance['private_dns_name']
          member.default['ipaddress'] = instance['private_ip']
          member.default['hostname'] = new_name
          member.default['priority'] = instance['private_ip'].gsub(/^.*\.(?=\d+)/, '').to_i

          # from mongodb overrides
          member.default['hidden'] = hidden_members.include?(name)

          Chef::Log.info("adding member to arr...#{member}")

          members << member
        end
      end
    end
    Chef::Log.info("members=#{members}")

    members
  end

  def self.find_keyspace(host="127.0.0.1", port=27017)
    puts "requiring mongo..."
    begin
      require 'mongo'
    rescue LoadError
      Chef::Log.error("Missing gem 'mongo'. Use the default recipe to install it first.")
    end

    puts "Executing shell script to query on given mongo"
    Chef::Log.info("Executing shell script to query on given mongo")

    old_keyspace=`mongo --eval "printjson(rs.status())" | egrep -i '^\s+"set"' | cut -d'"' -f4`
    puts "old_keyspace...#{old_keyspace}"
    Chef::Log.info("old_keyspace...#{old_keyspace}")
    old_keyspace
  end


end
