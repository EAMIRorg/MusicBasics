# https://cycling74.com/forums/mac-standalone-codesigning-2021-update
# Author: Dan Nigrin
require 'open3'

authority = "Developer ID Application: Clear Blue Media LLC (HSAYDGFEVC)"
entitlements = "/Users/VJ/Desktop/Music Basics.app/Contents/Music Basics.entitlements"
appbundle = "/Users/VJ/Desktop/Music Basics.app"
appname = "Music Basics"
resources = [];
count = 1;

# codesign the stuff in C74 folder
Dir.glob("#{appbundle}/Contents/Resources/C74/**/*.{mxo,dylib,framework,bundle}") do |f|
if !File.symlink?(f)
resources.push(f)
end
end

resources.each do |resource|
puts count.to_s + ": " + resource
cmd = "codesign -s \"#{authority}\" --timestamp --deep -f \"#{resource}\""
stdout, stderr, status = Open3.capture3(cmd)
raise stderr unless status.success?
end

resources.clear

# codesign the stuff in Frameworks folder
Dir.glob("#{appbundle}/Contents/Frameworks/**/*.{mxo,dylib,framework,bundle}") do |f|
if !File.symlink?(f)
resources.push(f)
end
end

resources.each do |resource|
puts count.to_s + ": " + resource
cmd = "codesign -s \"#{authority}\" --timestamp --deep -f \"#{resource}\""
stdout, stderr, status = Open3.capture3(cmd)
raise stderr unless status.success?
end

# codesign the Max executable
cmd = "codesign -f -s \"#{authority}\" --timestamp --deep --options runtime --entitlements \"#{entitlements}\" \"#{appbundle}\""
stdout, stderr, status = Open3.capture3(cmd)
raise stderr unless status.success?
