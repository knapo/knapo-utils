# Matz The Potato Dealer
# Copyright (C) 2009 by Krzysztof Knapik
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

# Usage:
# install xdotool
# Set zoom level to ZOOM
# ruby ziemniaki.rb X Y
# X and Y are rows and cols numbers

require File.join(File.dirname(__FILE__), 'farmer.lib')

ZOOM     = 1
DELTA    = {:x => 25, :y => 12}
DEFAULT_DIMENSIONS = {:x => 20, :y => 20}

# Fields you'd like to exclude from farming.
@@exclude = []

@@exclude << [10, 9]

(17..19).to_a.each do |x|
  (0..3).to_a.each do |y|
    @@exclude << [x, y]
  end
end

def farm_me(x_dim, y_dim)
  init_x, init_y = getxy
  y_dim.times do |row|
    cx = init_x + DELTA[:x] * row
    cy = init_y + DELTA[:y] * row
    x_dim.times do |col|
      doxy(cx, cy) unless @@exclude.include?([col, row])
      cx += DELTA[:x]
      cy -= DELTA[:y]
      sleep 0.05
    end
    sleep 0.5
  end
end

x_dim, y_dim = ARGV[0].to_i, ARGV[1].to_i
warn()
if x_dim == 0 || y_dim == 0
  x_dim, y_dim = DEFAULT_DIMENSIONS.values
  sleep 15
else
  sleep 5
  @@exclude = []
end
farm_me(x_dim, y_dim)


