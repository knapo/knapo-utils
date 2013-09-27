require 'time'
class Photo
  attr_reader :path, :rel_path, :group, :created_at, :number, :suffix, :scope, :extname, :old_name, :new_name, :new_path

  def initialize(path, scope)
    @path = path
    @old_name = File.basename(@path)
    @scope = scope
    @group = path.scan(/\/#{scope}\/[0-9]*/)
    @rel_path = path[path.index("/#{scope}/")..-1]
    @extname = File.extname(path).downcase.sub('.', '')
    set_name_parts
    set_created_at
  end

  def set_new_name(dir, album_name, new_number)
    #album_name = if created_at < Time.parse('2013-07-29 09:25:00 UTC') then 'ALBUM1'
    #else 'ALBUM2'
    #end
    created_on = created_at.strftime('%Y.%m.%d')
    @new_name = [created_on, '-', album_name, '_', "%04d" % new_number, @suffix, '-', @scope, '.', @extname].join
    @new_path = File.join(dir, @extname, @new_name)
  end
  
  def set_created_at
    return unless ['dng', 'nef', 'jpg', 'cr2'].include?(@extname)
    metadata  = `exiv2 -q pr #{@path}`
    timestamp = metadata.scan(/[0-9]{4}:[0-9]{2}:[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}/).first
    if timestamp
      parts = timestamp.split(/[\s:]/)
      parsable = "#{parts[0..2].join('-')} #{parts[3..-1].join(':')} UTC"
      @created_at = Time.parse(parsable)
    else
      return nil
    end
  end

  def fix_created_at(list, max_created_at)
    possible_neighbours = list.select{ |f| f.group == group && f.created_at && f.created_at <= max_created_at }
    previous_file = possible_neighbours.select { |f| f.number < @number }.max_by { |f| f.number } 
    next_file = possible_neighbours.select { |f| f.number > @number }.min_by { |f| f.number } 
    puts "Fixing created_at for #{@rel_path} based on #{[previous_file && previous_file.rel_path, next_file && next_file.rel_path].compact.join(' and ')}"
    if previous_file && next_file
      delta = next_file.created_at - previous_file.created_at
      @created_at = next_file.created_at - (delta/2.0).round
    elsif next_file
      @created_at = next_file.created_at - 1
    elsif previous_file
      @created_at = previous_file.created_at + 1
    else
      raise "!!! COULD NOT SET CREATED_AT FOR #{@path} !!!"
    end
  end

  def set_name_parts
    parts = File.basename(@path).scan(/([^_]+)_([\d]+)([^\.]*)/)[0]
    if parts.nil? || parts.empty?
      raise "Invalid filename: #{@path}"
    end
    @number = parts[1]
    @suffix = parts[2]
    @suffix = nil if @suffix == '-Edit'
  end

  def self.collection(paths, scope)
    paths.map{|path| self.new(path, scope)}
  end
end
