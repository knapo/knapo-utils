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

unless ARGV[0]
  puts "No directory given! #{ARGV[0]}"
  exit
end

@perform = ARGV.include?('PERFORM')

@dir = File.directory?(ARGV[0]) ? ARGV[0] : File.expand_path(File.join(File.dirname(__FILE__), ARGV[0]))
@dir = @dir + '/' unless @dir[-1] == '/'

@prefix = File.basename(@dir)

unless File.exists?(@dir) && File.directory?(@dir)
  puts "No such directory: #{@dir}"
  exit
end

puts "Directory: #{@dir}"

FILE_EXT = "*.{JPG,NEF,AVI,TIF,DNG,jpg,nef,avi,tif,dng}"

@subdirs = Dir[File.join(@dir, '*')].map{|d| d.split('/').last}.sort

# Get files for specific dirs
def file_list
  return Dir[File.join(@dir, '**', FILE_EXT)]
end

# Get all picture numbers
@numbers = file_list.map{|f| nameparts(f)[1].to_i}.uniq.sort
raise "Numbers include 0" if @numbers.include?(0)

@output_files = []

def rename_files(files)
  files.sort.each do |file|
    extname = File.extname(file).downcase
    suffix = File.basename(file, ".*")[-1]
    prefix, number, suffix = nameparts(file)

    newnumber = @numbers.index(number.to_i) + 1
    newfilename = [@prefix, '_', "%04d" % newnumber, suffix, extname].join

    subdir = File.dirname(file).sub(@dir, '').split('/').last
    newdir = File.join(@dir, subdir)
    FileUtils.mkdir_p(newdir)
    newfile = File.join(newdir, newfilename)

    @output_files << newfile
    msg = "moving *#{file.sub(@dir, '')}* to *#{newfile.sub(@dir, '')}*"
    puts msg

    next unless @perform
    FileUtils.mv(file, newfile, :force => true)
  end
end

rename_files(file_list)

puts "#{file_list.size} input files, #{@output_files.size} output files"
if @perform
  puts 'Done!'
else
  puts 'DRYRUN - files not renamed! (pass PERFORM)'
end

