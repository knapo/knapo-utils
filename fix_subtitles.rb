#!/usr/bin/env ruby
#
# Subtitles encoding converter.
#
# By default converts from WINDOWS-1250 to UTF-8.
#
# Author; Krzysztof Knapik
# http://knapo.net
#
# License: MIT
#
# Usage:
# `$ ruby fix_subtitles.rb [directory]`

require 'fileutils'

unless ARGV[0]
  puts "No directory given #{ARGV[0]}"
  exit
end

from_code = 'WINDOWS-1250'
to_code = 'UTF-8'
dir = File.directory?(ARGV[0]) ? ARGV[0] : File.expand_path(File.join(File.dirname(__FILE__), ARGV[0]))

puts "Directory: #{dir}"

Dir[File.join(dir, '*.txt')].each do |file|
  cmd = %(iconv --from-code #{from_code} --to-code #{to_code} "#{file}")
  content = `#{cmd}`
  File.open(file, 'w+'){ |f| f.write(content) }
end

puts 'Done!'
