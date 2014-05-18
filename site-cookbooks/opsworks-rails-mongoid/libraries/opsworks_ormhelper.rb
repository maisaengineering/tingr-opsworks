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
      require 'json'
      require 'bson'
    rescue LoadError => e
      Chef::Log.error("Missing required gems. Use the default recipe to install it first. Exception=#{e}")
    end

    Chef::Log.info("running config command")
    old_keyspace=`mongo --eval "printjson(rs.config())" | egrep -i '^\s+"_id"' -m 1 | cut -d'"' -f4`
    Chef::Log.info("OLD old_keyspace...#{old_keyspace}")

    # begin
    #
    #   Chef::Log.info("raw...#{config_raw}")
    #   old_keyspace=config["_id"]
    # rescue Exception => e
    #   Chef::Log.error("Unable to process node data. Please check logs. Exception=#{e}")
    # end

    @db = Mongo::MongoClient.new(host, port).db('admin')
    cmd = BSON::OrderedHash.new
    cmd['replSetGetStatus'] = 1

    cmd_result = @db.command(cmd)
    Chef::Log.info("cmd_result...#{cmd_result}")
    Chef::Log.info("cmd_result.set...#{cmd_result.try(:set)}")
    old_keyspace=cmd_result.try(:set)

    puts "NEW old_keyspace...#{old_keyspace}"
    Chef::Log.info("old_keyspace...#{old_keyspace}")

    Chef::Log.info("host=#{host}, port=#{port}")
    connection = Mongo::Connection.new(host, port)
    Chef::Log.info("connection=#{connection.inspect}")
    connection.database_info.each { |info| puts info.inspect}

    Chef::Log.info("reading collections...")
    connection.db("local").collection_names.each { |name| puts name }





    puts "inspecting...#{connection.inspect}"

    old_keyspace
  end


end
