default['mongodb']['config']['rest']="false"
default['mongodb']['config']['bind_ip']="0.0.0.0"
default['mongodb']['config']['port']="27017"
default['mongodb']['config']['dbpath'] = "/data/mongodb"
default['mongodb']['config']['logpath'] = "/data/log/mongodb/mongodb.log"


# AWS STACK CUSTOM JSON
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
#       },
#       "layers" : "ds-mongo-rpl,dr-ds-mongo-rpl",
#       "hidden" : "helios",
#       "arbiter" : "hestia"
#    }
# }
