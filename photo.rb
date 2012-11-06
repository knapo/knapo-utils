require 'time'
class Photo
  attr_reader :path, :created_at, :number, :suffix, :scope, :extname, :old_name, :new_name, :new_path

  def initialize(path, scope)
    @path = path
    @old_name = File.basename(@path)
    read_created_at
    set_name_parts
    @scope = scope
    @extname = File.extname(path).downcase.sub('.', '')
  end

  def set_new_name(dir, album_name, new_number)
    created_on = created_at.strftime('%Y.%m.%d')
    @new_name = [created_on, '-', album_name, '_', "%04d" % new_number, @suffix, '-', @scope, '.', @extname].join
    @new_path = File.join(dir, @extname, @new_name)
  end
  
  def read_created_at
    metadata  = `exiv2 pr #{@path}`
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
    previous_file = list.detect{|f| f.number < @number && f.created_at && f.created_at <= max_created_at}
    puts "Fixing created_at for #{@path} based on #{previous_file.path}"
    return unless previous_file
    @created_at = previous_file.created_at + 1
  end

  def set_name_parts
    parts = File.basename(@path).scan(/([^_]+)_([\d]+)([^\.]*)/)[0]
    @number = parts[1]
    @suffix = parts[2]
  end

  def self.collection(paths, scope)
    paths.map{|path| self.new(path, scope)}
  end
end
