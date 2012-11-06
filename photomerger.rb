#!/usr/bin/env ruby
#
# Mass media file renamer.
#
# Rename all media files (NEF, JPG, DNG etc.) in given directory with
# new prefix and numbering. All responding files will keep the same name.
#
# Author; Krzysztof Knapik
# http://knapo.net
#
# License: MIT
#
# Usage:
# `$ ruby renamer.rb [directory]`

require 'fileutils'
require 'yaml'

@@dir_to_observe = '/home/knapo/.local/share/Trash/files/*.jpg'
@@result_file = 'indo-pic-list.yml'

if File.exists?(@@result_file)
  @@files = YAML.load_file(@@result_file)
else
  @@files = []
end

puts 'observing...'

@@curent_files = nil

while true do
  @@current_files = Dir[@@dir_to_observe].sort
  @@files = (@@files + @@current_files).uniq
  File.open('indo-pic-list.yml','w+'){|g| g.write @@files.to_yaml}
  sleep(1)
end
