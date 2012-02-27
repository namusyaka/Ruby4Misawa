# -*- encoding: UTF-8 -*-

%w( uri open-uri optparse rubygems nokogiri ).each do | name |
  require name
end

class Misawa

  DOMAIN = 'http://jigokuno.com/'
  CATEGORIES = {
    "cecil" => 79,
    "D-Matt" => 25,
    "KAZ" => 1,
    "KOUNOIKE" => 29,
    "masa" => 13,
    "masao" => 53,
    "NAKAYAN" => 8,
    "SYUN" => 24,
    "ルシフェル" => 14,
    "あつしさん" => 64,
    "あの御方" => 37,
    "しょうへい" => 66,
    "すなお" => 38,
    "たばっち" => 52,
    "ちんちんでか男" => 57,
    "つっちー" => 7,
    "てづっちゃん" => 67,
    "とりっぴー" => 82,
    "なかじ" => 28,
    "のぶちゃん" => 22,
    "のぼる" => 49,
    "のりすけ" => 21,
    "はしもっさん" => 44,
    "はまちゃん" => 55,
    "ぴーなっつ" => 58,
    "まみのパパ" => 56,
    "りきお" => 85,
    "エ～イチ" => 83,
    "キヨシロー" => 17,
    "キング" => 84,
    "コウヘイ" => 3,
    "シュナイダー" => 34,
    "ショップ店員" => 12,
    "ジーンズ" => 36,
    "ジェイ" => 10,
    "ソドム" => 78,
    "タケ" => 54,
    "チーポー" => 35,
    "デスピサロ" => 46,
    "ドリモグ" => 40,
    "ナイト" => 50,
    "ハリソン・フォード" => 41,
    "バイトリーダー" => 71,
    "ファイナルボム" => 74,
    "フェイク" => 32,
    "マイク" => 65,
    "ミラージュ" => 5,
    "ラッシュさん" => 19,
    "リアル" => 81,
    "リチャード" => 80,
    "リュウー" => 26,
    "レオン" => 59,
    "吉岡" => 6,
    "久志" => 51,
    "玉木宏" => 43,
    "健二" => 70,
    "佐伯さん" => 76,
    "砂漠の狼" => 63,
    "坂本竜馬の子孫" => 27,
    "桜井" => 39,
    "時任" => 42,
    "実行委員" => 47,
    "小松っち" => 75,
    "松尾" => 23,
    "水谷" => 11,
    "袖まくり" => 60,
    "太陽 " => 68,
    "代官山" => 33,
    "大嶽一史" => 77,
    "拓真" => 31,
    "達也の兄ちゃん" => 72,
    "痴漢" => 15,
    "中村健" => 4,
    "田部" => 20,
    "東大生" => 45,
    "湯上谷" => 16,
    "藤井" => 9,
    "道明寺" => 61,
    "風雲児達" => 86,
    "北岡" => 62,
    "野村" => 2,
    "野茂" => 30,
    "零" => 69,
    "零" => 73,
    "和田" => 48   
  }

  attr_reader :category, :page

  def initialize(category, page = 0)
    @category = CATEGORIES[category]
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
    begin
      open(URI.encode(uri)).read
    rescue OpenURI::HTTPError
      return nil
    end
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
