require 'chef/node'

# include Chef::ResourceDefinitionList::MongoDB

class Chef::ResourceDefinitionList::OpsWorksHelper

  # true if we're on opsworks, false otherwise
  def self.opsworks?(node)
    node['opsworks'] != nil
  end

  # return Chef Nodes for this replicaset / layer
  def self.replicaset_members(node)
    members = []
    # FIXME -> this is bad, we're assuming replicaset instances use a single layer
    replicaset_layer_slug_name = node['opsworks']['instance']['layers'].first
    instances = node['opsworks']['layers'][replicaset_layer_slug_name]['instances']
    instances.each do |name, instance|
      if instance['status'] == 'online'
        member = Chef::Node.new
        Chef::Log.info("CB member name BEFORE = #{name}")
        new_name = "#{name}.localdomain"

        Chef::Log.info("CB member name AFTER = #{new_name}")

        member.name(new_name)
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

  # true if we're on opsworks, false otherwise
  # def self.configure_replicaset?(replicaset, replicaset_name, replicaset_layer_instances )
  #   Chef::Log.debug("About to call MongoDB for rpl setup replicaset=#{replicaset}, replicaset_name=#{replicaset_name}, replicaset_layer_instances=#{replicaset_layer_instances}")
  #   # MongoDB.configure_replicaset(new_resource.replicaset, replicaset_name, replicaset_layer_instances)
  # end

end
