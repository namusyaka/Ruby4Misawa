require 'open-uri'
require 'kconv'
require 'rubygems'
require 'nokogiri'

class Misawa
  DOMAIN       = 'http://jigokuno.com/'
  @@categories = {}

  class NotFoundError < ArgumentError; end

  Nokogiri.HTML(open(DOMAIN).read).css('dl').each do |dl|
    if dl.children[0].inner_html.toutf8 == '惚れさせ男子達'
      dl.children[2].children[1].children.to_a.delete_if{|node|node.class == Nokogiri::XML::Text}.each do |li|
        a = li.child
        @@categories[a.text.scan(/(.+?)(?:\([0-9]+\))?$/)[0][0]] = a[:href].scan(/cid=([0-9]+)/)[0][0]
      end
    end
  end

  def initialize(name, page = 0)
    @name = name
    @cid  = @name.is_a?(Integer) ? @name : name_to_cid(@name)
    @page = page
  end

  def scrape
    data = []

    begin
      nokogiri = Nokogiri.HTML(open(misawa_uri).read)
    rescue OpenURI::HTTPError
      raise NotFoundError
    end

    # parse some attributes
    nokogiri.xpath('//comment()[contains(., "rdf")]').each do |entry|
      attributes = Nokogiri.XML(entry.to_s.toutf8.gsub(/^<!--|-->$/, "")).child.css('rdf|Description')[0].attributes
      data << %w[title date identifier].inject({}) do |result, key|
        result[key.to_sym] = attributes[key].value
        result
      end
    end

    # parse images
    nokogiri.css('img.pict').to_a.each_with_index { |image, i|
      data[i].merge!(:image => image['src'], :body => image['alt'])
    }

    data
  end

  private

  def misawa_uri
    "#{DOMAIN}?cid=#{@cid}&page=#{@page}"
  end

  def name_to_cid(name)
    @@categories[name]
  end
end
