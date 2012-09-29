# -*- encoding: UTF-8 -*-

%w(
  uri
  open-uri
  kconv
  optparse
  rubygems
  nokogiri
).each { | name | require name }

class Misawa

  class NotFoundError < ArgumentError; end;

  DOMAIN = 'http://jigokuno.com/'

  @@categories = {}

  Nokogiri.HTML(open(DOMAIN).read).css('dl').each do |dl|
    if dl.children[0].inner_html.toutf8 == '惚れさせ男子達'
      dl.children[2].children[1].children.to_a.delete_if{|node| node.class == Nokogiri::XML::Text}.each do |li|
        a = li.child
        @@categories[a.text.scan(/(.+?)(?:\([0-9]+\))?$/)[0][0]] = a[:href].scan(/cid=([0-9]+)/)[0][0]
      end
    end
  end

  attr_reader :category, :page

  def initialize(category, page = 0)
    raise NotFoundError unless @@categories[category]
    @category = @@categories[category]
    @page = page =~ /^[0-9]+?\.\.[0-9]+?$/ ? eval(page) : page
  end

  def scrape
    create_uri.inject([]) do | result, uri |
      body = get_body(uri)
      Nokogiri.HTML(body).css('img.pict').map { | img | result << img['src'] } if body
      result
    end
  end

  class << self;

    def save_misawa(category, page)
      misawa = self.new(category, page)
      misawa.scrape.each_with_index do | src, i |
        File.open("#{misawa.category}-#{i}.gif", 'w') { | f | f.write(misawa.get_body(src)) }
      end
    end

    def uri_misawa(category, page)
      misawa = self.new(category, page)
      misawa.scrape.each_with_index do | src, i |
        puts "#{misawa.category}-#{i} : #{src} "
      end
    end

    def method_missing(name, *args)
      raise ArgumentError;
    end

  end

  def get_body(uri)
    open(URI.encode(uri)).read
  end

  def create_uri
    if @page.is_a?(Range)
      base = "#{DOMAIN}/?cid=#{@category}&page="
      @page.map { | i | "#{base}#{i}" }
    else
      ["#{DOMAIN}/?cid=#{@category}&page=#{@page}"]
    end
  end

end

if $0 === __FILE__

  OptionParser.new do | opt |

    arguments = {}

    opt.on('-t [TYPE]', '--type [TYPE]') do | value |
      arguments[:type] = value
    end
    opt.on('-p [PAGE]', '--page [PAGE]') do | value |
      arguments[:page] = value
    end
    opt.on('-c [CATEGORY]', '--category [CATEGORY]') do | value |
      arguments[:category] = value
    end

    opt.parse!(ARGV)
    Misawa.send("#{arguments[:type] || 'uri'}_misawa", arguments[:category], arguments[:page])
  end

end
