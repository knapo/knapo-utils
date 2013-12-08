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
# `$ ruby picombiner.rb [dir] [tile1] [tile2]`
#

require 'fileutils'

FILE_RULE = "*.{JPG,jpg,PNG,png,TIF,tif}"
COLORS = ['white', 'black']
BORDER_FACTOR = 0.0125

@in_dir  = File.directory?(ARGV[0]) ? ARGV[0] : File.expand_path(File.join(File.dirname(__FILE__), ARGV[0]))
@tmp_dir = File.join(@in_dir, 'tmp')
@out_dir = File.join(@in_dir, 'out')

@tiles = ARGV[1..ARGV.size-1]
raise "tile not given" if @tiles.empty?

@files = Dir[File.join(@in_dir, FILE_RULE)]
raise "No files found!" if @files.empty?

@base_border = (`identify -format "%w" '#{@files.first}'`.to_f * BORDER_FACTOR).to_i / 2

puts "Set border to: #{@base_border}"
FileUtils.rm_rf(@out_dir)
FileUtils.mkdir_p(@out_dir)

def files_in(dir)
  Dir[File.join(dir, FILE_RULE)].sort
end

def output_file(tile, color)
  first_file = Dir[File.join(@in_dir, FILE_RULE)].sort.first
  file_name = [File.basename(first_file, ".*"), '-', tile, color[0], File.extname(first_file)].join
  return File.join(@out_dir, file_name)
end

def exec(cmd)
  puts cmd
  `#{cmd}`
end

def montage(tile, color)
  file_list = files_in(@in_dir).map{|f| "'#{f}'"}.join(' ')
  exec "montage -background #{color} -geometry +#{@base_border}+#{@base_border} -tile #{tile} #{file_list} '#{output_file(tile, color)}'"
end

def fix_border(tile, color)
  file = output_file(tile, color)
  exec "convert -bordercolor #{color} -border #{@base_border}x#{@base_border} '#{file}' '#{file}'"
end

COLORS.each do |color|
  @tiles.each do |tile|
    puts "*** #{tile} with #{color} #{@base_border*2}px ***" 
    montage(tile, color)
    fix_border(tile, color)
  end
end
