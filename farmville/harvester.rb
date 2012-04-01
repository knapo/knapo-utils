# Knapo The Harvester
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
# ruby kury.rb X Y
# X and Y are rows and cols numbers

require File.dirname(__FILE__) + '/farmer.lib'

class Harvester
  ZOOM = 2
  
  attr_accessor :delta_x, :delta_y

  def initialize(delta)
    @delta_x = delta[:x]
    @delta_y = delta[:y]
  end

  def harvest(x_dim, y_dim)
    init_x, init_y = getxy
    y_dim.times do |col|
      cx = init_x + @delta_x * col
      cy = init_y + @delta_y * col
      x_dim.times do
        harvest_single(cx, cy)
        cx += @delta_x
        cy -= @delta_y
      end
    end
  end

  private

  def harvest_single(item_x, item_y)
    doxy(item_x, item_y) # Click on animal/tree
    menu_click(3)
    gotoxy(item_x, item_y) # Back to origin
  end

end