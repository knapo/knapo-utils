#!/usr/bin/env ruby

#
# Simple script displaying pretty formated user's git history grouped by days,
# extended with computer working times.
#
# It quickly reminds you what, how hard and how long you were working on :)
#
# By default if displays entries for last day, but you can give no of days
# as an argument.
#
# Author; Krzysztof Knapik
# http://knapo.net
#
# License: MIT
#
# Usage:
#
# $./git_history 2
#
# Tue 17 Jan 2012
# 07:48-16:28 (7:58)
# ---------------------------------------
# Making me happy #6576
# Fixing the world #6578
#
# Wed 18 Jan 2012
# 07:48-16:28 (8:40)
# ---------------------------------------
# Making our client happy #6577
# Still fixing the world #6578

require 'date'

def time_to_minutes(time)
  hours, minutes = time.split(':')
  hours.to_i * 60 + minutes.to_i
end

def minutes_to_time(min)
  "#{min / 60}:#{"%02d" % (min % 60)}"
end

def time_between(start_hour, end_hour)
  minutes_to_time(time_to_minutes(end_hour) - time_to_minutes(start_hour))
end

def computer_working_times(date)
  entries = []
  `last reboot -100 | grep "#{Date.parse(date).strftime("%a %b %e")}"`.each_line do |line|
    start_hour, end_hour = line.scan(/(\d\d:\d\d) - (\d\d:\d\d)/).flatten
    entries << "#{start_hour}-#{end_hour} (#{time_between(start_hour, end_hour)})" if start_hour && end_hour
  end
  entries
end

date_from = Date.today - (ARGV[0] || 1).to_i

author  = `git config user.name`.strip

# git entries in date & message format
cmd     = "git log --author=\"#{author}\" --branches --remotes --no-merges --reverse --pretty=format:\"%ad;%s\" --since=\"#{date_from.to_s}\""

# convert log entries into array
commits = `#{cmd}`.split("\n").map{|res| [Date.parse(res.split(';')[0]).to_s, res.split(';')[1]]}

# select unique dates
dates   = commits.map{|r| r[0]}.uniq.sort

current_date = nil

dates.each do |date|
  unless current_date == date
    puts "\n"
    puts Date.parse(date).strftime("%a %d %b %Y")
    puts computer_working_times(date).join("\n")
    puts '---------------------------------------'
  end
  commits.select{|r| r[0] == date}.map{|r| r[1]}.uniq.each do |result|
    puts result
  end
  current_date = date
end
