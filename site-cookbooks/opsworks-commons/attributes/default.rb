# node.override['mongodb'] = {
#     "cluster_name" => "CB Rpl 1",
#      "config" => {
#        "rest" => "false",
#        "bind_ip" => "0.0.0.0",
#        "replSet" => "CB Rpl 1"
#     }
# }

default['mongodb']['config']['rest']="false"
default['mongodb']['config']['bind_ip']="0.0.0.0"
default['mongodb']['config']['bind_ip']="27017"

### OPSWORKS CUSTOM JSON
# {
#    "opsworks":{
#       "data_bags":{
#          "aws":{
#             "main":{
#                "aws_access_key_id":"",
#                "aws_secret_access_key":""
#             }
#          }
#       }
#    },
#    "mongodb":{
#       "mms_agent":{
#          "api_key":""
#       }
#    }
# }
