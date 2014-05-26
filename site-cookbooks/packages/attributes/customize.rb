# MAISA override
# puts "CB echo 0...#{default[:packages]}"
# puts "CB echo 1...#{default[:packages][:dist_only]}"
# default[:packages][:dist_only] = false
#
# puts "CB echo...include attributes"
# include_attribute "packages::customize"


packages Mash.new unless attribute?("packages")

# Toggle for recipes to determine if we should rely on distribution packages
# or gems.
packages[:dist_only] = false unless packages.has_key?(:dist_only)
