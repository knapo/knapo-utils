#!/usr/bin/env ruby

require 'fileutils'

FILE_RULE = "*.{JPG,NEF}"

in_dir = ARGV[0] if File.directory?(ARGV[0])

nef_all = Dir[File.join(in_dir, "*.NEF")]
jpg_all = Dir[File.join(in_dir, "*.JPG")]

raise "No NEF files found!" if nef_all.empty?
raise "No JPG files found!" if jpg_all.empty?

def basename(f)
  File.basename(f, ".*")
end

file_names_k = jpg_all.map{ |f| basename(f) }

nef_k = nef_all.select{ |f| file_names_k.include?(basename(f)) }
nef_e = nef_all - nef_k

puts "TOTAL: #{nef_all.size} files"
puts "E: #{nef_e.size} files"
puts "K: #{nef_k.size} files"

out_dir_k = File.join(File.dirname(in_dir), 'nef-k')
out_dir_e = File.join(File.dirname(in_dir), 'nef-e')

FileUtils.mkdir_p(out_dir_e)
FileUtils.mkdir_p(out_dir_k)

nef_k.each do |f|
  target = File.join(out_dir_k, File.basename(f))
  puts "moving #{f} to #{target}"
  FileUtils.mv(f, target, :force => true)
end

nef_e.each do |f|
  target = File.join(out_dir_e, File.basename(f))
  puts "moving #{f} to #{target}"
  FileUtils.mv(f, target, :force => true)
end
