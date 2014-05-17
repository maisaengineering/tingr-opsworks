require 'chef/node'

# include Chef::ResourceDefinitionList::MongoDB

class Chef::ResourceDefinitionList::OpsWorksHelper

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
      layers << node[:mongodb][:layers]
      hidden_members << node[:mongodb][:hidden]
    end
    Chef::Log.info("layers=#{layers.inspect}")

    Chef::Log.info("hidden_members=#{hidden_members.inspect}")

    layers.uniq.each do |layer|
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
          members << member
        end
      end
    end
    #
    #
    # instances = node['opsworks']['layers'][node_layer]['instances']
    # instances.each do |name, instance|
    #   if instance['status'] == 'online'
    #     member = Chef::Node.new
    #     new_name = "#{name}.localdomain"
    #     member.name(name)
    #     member.default['fqdn'] = instance['private_dns_name']
    #     member.default['ipaddress'] = instance['private_ip']
    #     member.default['hostname'] = new_name
    #     member.default['priority'] => instance['private_ip'].gsub(/^.*\.(?=\d+)/, '').to_i,
    #     members << member
    #   end
    # end
    members
  end


  # true if we're on opsworks, false otherwise
  # def self.configure_replicaset?(replicaset, replicaset_name, replicaset_layer_instances )
  #   Chef::Log.debug("About to call MongoDB for rpl setup replicaset=#{replicaset}, replicaset_name=#{replicaset_name}, replicaset_layer_instances=#{replicaset_layer_instances}")
  #   # MongoDB.configure_replicaset(new_resource.replicaset, replicaset_name, replicaset_layer_instances)
  # end

end
