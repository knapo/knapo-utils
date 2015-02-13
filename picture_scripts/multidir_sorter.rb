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
require File.expand_path('../photo', __FILE__)

# Custom config
@max_created_at = Time.parse('2014-11-29 12:00:00 UTC')
@album_name = 'New-Zealand'

unless ARGV[0]
  puts "No directory given! #{ARGV[0]}"
  exit
end

@perform = ARGV.include?('PERFORM')

@dir = File.directory?(ARGV[0]) ? ARGV[0] : File.expand_path(File.join(File.dirname(__FILE__), ARGV[0]))
@dir = @dir + '/' unless @dir[-1] == '/'

unless File.exists?(@dir) && File.directory?(@dir)
  puts "No such directory: #{@dir}"
  exit
end

@dirs = Dir[File.join(@dir, '*')].sort

if @dirs.empty? || @dirs.detect{|d| !File.directory?(d) }
  puts "Invalid subdirs: #{@dirs.inspect}"
  exit
end

@groups = @dirs.map{|d| File.basename(d)}

puts "GROUPS: #{@groups.join(', ')}"

FILE_EXT = "*.{JPG,NEF,AVI,TIF,DNG,MOV,jpg,nef,avi,tif,dng,mov}"

# Split filename for parts (prefix + number + suffix)
def nameparts(f)
  File.basename(f).scan(/([^_]+)_([\d]+)([^\.]*)/)[0]
end

# Get files in specific dir
def file_list(group)
  return Dir[File.join(@dir, group, FILE_EXT)].sort
end

@files = {}

puts 'Listing files for each group...'
@groups.each do |group|
  puts 'GROUP: ' + group
  @files[group] = Photo.collection(file_list(group))
  puts "Found #{@files[group].size} files."
end

puts "Max created_at is #{@max_created_at}"
puts "Album name is #{@album_name}"

puts 'Fixing missing timestamps...'
@files.each do |group, list|
  list.sort!{|a, b| a.number <=> b.number }
  list.each do |file|
    if file.created_at.nil? || file.created_at > @max_created_at
      file.fix_created_at(list, @max_created_at)
    end
  end
end

@all_files = @files.values.flatten
@all_files.sort!{ |a,b| [a.created_at, a.number] <=> [b.created_at, b.number] }

@all_files.each_with_index do |file, number|
  file.set_new_name(@dir, @album_name, number + 1)
  FileUtils.mkdir_p(File.dirname(file.new_path)) if @perform
  msg = "moving *#{file.rel_path}* to *#{file.new_name}* [#{file.created_at.to_s}]"
  puts msg
  FileUtils.mv(file.path, file.new_path, :force => true) if @perform
end

if @perform
  puts 'Done!'
else
  puts 'DRYRUN - files not renamed!'
end

