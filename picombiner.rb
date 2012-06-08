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
# `$ ruby picombiner.rb [dir]`
#

require 'fileutils'

FILE_RULE = "*.{JPG,jpg,PNG,png,TIF,tif}"
COLORS = ['white', 'black']
BORDER_FACTOR = 0.0125
DIRECTIONS = {:horizontal => "+append", :vertical => "-append"}

@@in_dir  = File.directory?(ARGV[0]) ? ARGV[0] : File.expand_path(File.join(File.dirname(__FILE__), ARGV[0]))
@@tmp_dir = File.join(@@in_dir, 'tmp')
@@out_dir = File.join(@@in_dir, 'out')

@@files = Dir[File.join(@@in_dir, FILE_RULE)]
raise "No files found!" if @@files.empty?

@@base_border = (`identify -format "%w" #{@@files.first}`.to_f * BORDER_FACTOR).to_i

FileUtils.rm_rf(@@out_dir)
FileUtils.mkdir_p(@@out_dir)

def files_in(dir)
  Dir[File.join(dir, FILE_RULE)]
end

def output_file(direction, color)
  first_file = Dir[File.join(@@in_dir, FILE_RULE)].sort.first
  file_name = [File.basename(first_file, ".*"), direction[0], color[0], File.extname(first_file)].join
  return File.join(@@out_dir, file_name)
end

def picture_border(idx, total)
  return (idx == 0 || idx == total-1) ? @@base_border : 0
end

def exec(cmd)
  puts cmd
  `#{cmd}`
end

def border_im_operator(border, direction)
  case direction 
    when :horizontal then "#{border}x#{@@base_border}"
    when :vertical then "#{@@base_border}x#{border}"
    else raise "Invalid IM direction"
  end
end

def border_each!(direction, color)
  @@files.each_with_index do |f, idx|
    file_path = File.join(@@tmp_dir, File.basename(f))
    current_border = picture_border(idx, @@files.size)
    exec "convert -bordercolor #{color} -border #{border_im_operator(current_border, direction)} '#{f}' '#{file_path}'"
  end
end

def combine!(direction, color)
  file_list = Dir[File.join(@@tmp_dir, FILE_RULE)].join(' ')
  exec "convert #{file_list} #{DIRECTIONS[direction]} '#{output_file(direction, color)}'"
end

DIRECTIONS.keys.each do |direction|
  COLORS.each do |color|
    puts "*** #{direction} bordering with #{color} #{@@base_border}px ***" 
    begin
      FileUtils.mkdir_p(@@tmp_dir)
      border_each!(direction, color)
      combine!(direction, color)
    ensure
      FileUtils.rm_rf(@@tmp_dir)
   end
  end
end
