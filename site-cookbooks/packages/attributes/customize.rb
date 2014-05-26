packages Mash.new unless attribute?("packages")
packages[:dist_only] = false unless packages.has_key?(:dist_only)

include_attribute "packages::customize"
