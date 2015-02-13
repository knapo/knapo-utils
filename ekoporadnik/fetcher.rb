#!/usr/bin/env ruby
require 'excon'
require 'nokogiri'
require 'ap'
require 'open-uri'
require 'fileutils'

class Fetcher
  URL = 'http://www.ekoporadnikurody.pl/poradnik/wp-content/plugins/jquery_diamond_flipbook/lib/short.php'

  attr_reader :nr, :cat, :dir, :html_file, :image_urls

  def initialize(nr)
    @nr = nr
    @cat = "nr#{nr}"
    @dir = File.join('data', cat)
    @html_file = File.join(dir, "content.html")
  end

  def self.process
    (1..9).each do |nr|
      puts "Fetching nr#{nr}"
      Fetcher.new(nr).process
    end
  end

  def process
    create_dir
    get_html unless File.exists?(html_file)
    parse_image_urls
    get_images
    create_pdf
  end

  def create_dir
    FileUtils.mkdir_p(dir)
  end

  def get_html
    response = Excon.post(URL,
      body: "is_as_template=true&cat=#{cat}",
      headers: { "Content-Type" => "application/x-www-form-urlencoded" })
    File.open(File.join(dir, "content.html"), 'w+') { |f| f.write(response.body) }
  end

  def parse_image_urls
    noko = Nokogiri::HTML(File.read(html_file))
    @image_urls = noko.css('#fb5-book > div, .fb5-double').map{ |d| d[:style][/(http[^)]+)/] }.compact.uniq
  end

  def get_images
    @image_urls.each_with_index do |image_url, index|
      get_single_image(image_url, index)
    end
  end

  def get_single_image(url, index)
    path = File.join(dir, "#{index}-#{File.basename(url)}")
    puts "Saving #{url} to #{path}"
    return if File.exists?(path)
    File.open(path, 'wb') do |file|
      file.write open(URI.encode(url)).read
    end
  end

  def create_pdf
    jpgs_path = "#{dir}/*.pdf"
    pdf_path = "#{dir}/#{cat}.pdf"
    puts "Creating #{pdf_path}..."
    `convert -resize 1240x1750 -compose Copy -gravity center -extent 1240x1750 -density 150 #{jpgs_path} #{pdf_path}`
  end
end

Fetcher.process if $0 == __FILE__
