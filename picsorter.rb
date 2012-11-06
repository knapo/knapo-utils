#!/usr/bin/env ruby

require 'fileutils'
require File.expand_path('../photo', __FILE__)

unless ARGV[0]
  puts "No directory given! #{ARGV[0]}"
  exit
end

@@perform = ARGV.include?('PERFORM')

@@dir = File.directory?(ARGV[0]) ? ARGV[0] : File.expand_path(File.join(File.dirname(__FILE__), ARGV[0]))
@@dir = @@dir + '/' unless @@dir[-1] == '/'

unless File.exists?(@@dir) && File.directory?(@@dir)
  puts "No such directory: #{@@dir}"
  exit
end

@@dirs = Dir[File.join(@@dir, '*')]

if @@dirs.size < 2 || @@dirs.detect{|f| !File.directory?(f) }
  puts "Invalid subdirs: #{@@dirs.inspect}"
  exit
end

#TODO
@@max_created_at = TODO # Time.parse('2012-10-08 23:59:00 UTC')
@@album_name = TODO

@@scopes = @@dirs.map{|d| File.basename(d)}

puts "SCOPES: #{@@scopes.join(', ')}"

FILE_EXT = "*.{JPG,NEF,AVI,TIF,DNG,jpg,nef,avi,tif,dng}"

# Split filename for parts (prefix + number + suffix)
def nameparts(f)
  File.basename(f).scan(/([^_]+)_([\d]+)([^\.]*)/)[0]
end

# Get files in specific dir
def file_list(scope)
  return Dir[File.join(@@dir, scope, '**', FILE_EXT)]
end

@@files = {}

puts 'Listing files for each scope...'
@@scopes.each do |scope|
  @@files[scope] = Photo.collection(file_list(scope), scope)
end

puts "Max created_at is #{@@max_created_at}"
puts "Album name is #{@@album_name}"

puts 'Fixing missing timestamps...'
@@files.each do |scope, list|
  list.sort!{|a, b| b.number <=> a.number }
  list.each do |file|
    if file.created_at.nil? || file.created_at > @@max_created_at
      file.fix_created_at(list, @@max_created_at)
    end
  end
end

@@all_files = @@files.values.flatten
@@all_files.sort!{ |a,b| a.created_at <=> b.created_at }

@@all_files.each_with_index do |file, number|
  file.set_new_name(@@dir, @@album_name, number + 1)
  FileUtils.mkdir_p(File.dirname(file.new_path))
  msg = "moving *#{file.path}* to *#{file.new_path}*"
  puts msg
  FileUtils.mv(file.path, file.new_path, :force => true) if @@perform
end

if @@perform
  puts 'Done!'
else
  puts 'DRYRUN - files not renamed!'
end

