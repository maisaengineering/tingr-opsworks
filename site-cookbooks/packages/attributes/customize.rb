# MAISA override
# puts "CB echo 0...#{default[:packages]}"
# puts "CB echo 1...#{default[:packages][:dist_only]}"
# default[:packages][:dist_only] = false
#
# puts "CB echo...include attributes"
# include_attribute "packages::customize"


Chef::Log.info("CB echo 0...#{default[:packages]}")
packages Mash.new unless attribute?("packages")

Chef::Log.info("CB echo 1...#{default[:packages]}")

# Toggle for recipes to determine if we should rely on distribution packages
# or gems.
Chef::Log.info("CB echo 2...#{default[:packages][:dist_only]}")
packages[:dist_only] = false unless packages.has_key?(:dist_only)
Chef::Log.info("CB echo 3...#{default[:packages][:dist_only]}")
