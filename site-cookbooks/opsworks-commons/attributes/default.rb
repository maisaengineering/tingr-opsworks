# node.override['mongodb'] = {
#     "cluster_name" => "CB Rpl 1",
#      "config" => {
#        "rest" => "false",
#        "bind_ip" => "0.0.0.0",
#        "replSet" => "CB Rpl 1"
#     }
# }

default[:opsworks-commons][:ec2] = false
default[:opsworks-commons][:ebs] = {
  :raid => false,
  :size => 20 # size is in GB
}
