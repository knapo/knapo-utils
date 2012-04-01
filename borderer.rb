#!/usr/bin/env ruby
#
# Mass picture borderer.
#
# Author; Krzysztof Knapik
#
# License: MIT
#
# Usage:
# 
# `$ ruby borderer.rb [border_size]`
#

require 'fileutils'

in_dir  = File.directory?(ARGV[0]) ? ARGV[0] : File.expand_path(File.join(File.dirname(__FILE__), ARGV[0]))
out_dir = File.join(in_dir, 'bordered')

border_width = ARGV[1].to_i
border_width = 16 if border_width == 0

FileUtils.mkdir_p(out_dir)

Dir["#{in_dir}/*.{JPG,jpg,PNG,png}"].each do |img|
  filename = File.basename(img)
  cmd = "convert -bordercolor black -border #{border_width}x#{border_width} '#{img}' '#{File.join(out_dir, filename)}'"
  puts cmd
  `#{cmd}`
end