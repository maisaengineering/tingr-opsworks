# node.override['mongodb'] = {
#     "cluster_name" => "CB Rpl 1",
#      "config" => {
#        "rest" => "false",
#        "bind_ip" => "0.0.0.0",
#        "replSet" => "CB Rpl 1"
#     }
# }

default['mongodb'] = {
    "cluster_name" => "default",
     "config" => {
       "rest" => "false",
       "bind_ip" => "0.0.0.0",
       "port" => "27017"
    }
}

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
