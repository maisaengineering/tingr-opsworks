require 'chef/node'

class Chef::ResourceDefinitionList::OpsWorksORMHelper
  def self.replicaset_members(node)
    members = []
    hidden_members = []
    arbiter=[]
    layers = [ node['opsworks']['instance']['layers'].first ]

    # from mongodb overrides
    unless node[:mongodb].nil?
      layers |= node[:mongodb][:layers].split(",") unless node[:mongodb][:layers].nil?
      hidden_members |= node[:mongodb][:hidden].split(",") unless node[:mongodb][:hidden].nil?
      arbiter |= node[:mongodb][:arbiter].split(",") unless node[:mongodb][:arbiter].nil?
    end

    layers.each do |layer|
      instances = node['opsworks']['layers'][layer]['instances']
      next if instances.nil?
      instances.each do |name, instance|
        if instance['status'] == 'online'
          Chef::Log.info("online instance=#{instance}")
          member = Chef::Node.new
          member.name(name)
          member.default['name'] = name
          member.default['hostname']=name
          member.default['fqdn'] = instance['private_dns_name']
          member.default['ipaddress'] = instance['private_ip']
          member.default['priority'] = instance['private_ip'].gsub(/^.*\.(?=\d+)/, '').to_i/100.to_f

          # from mongodb overrides
          member.default['hidden'] = hidden_members.include?(name)
          member.default['arbiter'] = arbiter.include?(name)
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
      require 'bson'
    rescue LoadError => e
      Chef::Log.error("Missing required gems. Use the default recipe to install it first. Exception=#{e}")
    end

    begin
      @keyspace=nil
      @db = Mongo::MongoClient.new(host, port).db('admin')
      cmd = BSON::OrderedHash.new
      cmd['replSetGetStatus'] = 1
      cmd_result = @db.command(cmd)
      cmd_result.each do |k, v|
        if "set".eql?(k)
          @keyspace=v
        end
      end
    rescue => msg
      Chef::Log.warn("Mostly ReplicaSet not found. May be time to initialize? Exception=#{msg}")
    end

    @keyspace
  end

end
