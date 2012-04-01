# Matz The Farmer
# Copyright (C) 2009 by Jaroslaw Skrzypek & Krzysztof Knapik
#  
# Legal stuff: 
# THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
# APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
# HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
# OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
# IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
# ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
# IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
# WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
# THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
# GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
# USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
# DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
# PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
# EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGES.
#
# Copying, modifing, distribution, redistribution, selling or providing in any way to any third party users
# is strictly prohibited without written permission from author.
# This software can be used for educational purposes only

@@config_file = File.dirname(__FILE__) + '/config.yml'

def menu_click(pos)
  item_x, item_y = getxy
  menu_delta_x = 30
  menu_delta_y = (pos - 0.5) * 21
  doxy(item_x + menu_delta_x, item_y + menu_delta_y)
end

def warn
  puts "Make sure that zoom level is set to #{ZOOM}"
end

def getxy
  x, y = `xdotool getmouselocation`.split
  x = x.split(':')[1].to_i
  y = y.split(':')[1].to_i
  [x, y]
end

def gotoxy(x, y)
   rx = x + (rand * 2 - 1).round
   ry = y + (rand * 2 - 1).round
  `xdotool mousemove #{rx} #{ry}`
end

def click
  `xdotool click 1`
end

def doxy(x, y)
  gotoxy(x, y)
  click
end


