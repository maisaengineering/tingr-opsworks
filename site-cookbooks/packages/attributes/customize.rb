# MAISA override
puts "CB echo 0...#{default[:packages]}"
puts "CB echo 1...#{default[:packages][:dist_only]}"
default[:packages][:dist_only] = false

puts "CB echo...include attributes"
include_attribute "packages::customize"
