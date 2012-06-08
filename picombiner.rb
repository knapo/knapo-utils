#!/usr/bin/env ruby
#
# Simple picture combiner.
#
# Author; Krzysztof Knapik
#
# License: MIT
#
# Usage:
# 
# `$ ruby picombiner.rb [dir] [border_size]`
#

require 'fileutils'

FILE_RULE = "*.{JPG,jpg,PNG,png,TIF,tif}"
@@in_dir  = File.directory?(ARGV[0]) ? ARGV[0] : File.expand_path(File.join(File.dirname(__FILE__), ARGV[0]))
@@tmp_dir = File.join(@@in_dir, 'tmp')

BORDER_COLOR = 'black'
@@border_width = ARGV[1].to_i
@@border_width = 50 if @@border_width == 0

@@files = Dir[File.join(@@in_dir, FILE_RULE)]

def files_in(dir)
  Dir[File.join(dir, FILE_RULE)]
end

def output_file
  first_file = Dir[File.join(@@in_dir, FILE_RULE)].sort.first
  file_name = [File.basename(first_file, ".*"), 'k', File.extname(first_file)].join
  return File.join(@@in_dir, file_name)
end

def picture_border(idx, total)
  return (idx == 0 || idx == total-1) ? @@border_width : 0
end

def exec(cmd)
  puts cmd
  `#{cmd}`
end

def border_each!
  files = @@files.select{|f| f != output_file}
  files.each_with_index do |f, idx|
    file_path = File.join(@@tmp_dir, File.basename(f))
    border = picture_border(idx, files.size)
    exec "convert -bordercolor #{BORDER_COLOR} -border #{border}x#{@@border_width} '#{f}' '#{file_path}'"
  end
end

def combine!
  file_list = Dir[File.join(@@tmp_dir, FILE_RULE)].join(' ')
  exec "convert #{file_list} +append '#{output_file}'"
end

begin
  FileUtils.mkdir_p(@@tmp_dir)
  border_each!
  combine!
ensure
  FileUtils.rm_rf(@@tmp_dir)
end
