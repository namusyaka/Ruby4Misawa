# -*- encoding: UTF-8 -*-

Gem::Specification.new do | spec |
  spec.name = 'Ruby4Misawa'
  spec.version = '0.1.1'
  spec.summary = 'スクレイピングライブラリ for 地獄のミサワ'
  spec.description = '地獄のミサワブログにあるURLがとれたり、そのまま画像を保存したりできます。'
  spec.homepage = 'https://github.com/namusyaka/Ruby4Misawa'
  spec.author = 'namusyaka'
  spec.email = 'namusyaka@gmail.com'
  spec.files = %w( README.rdoc Ruby4Misawa-0.1.gemspec Gemfile lib lib/Ruby4Misawa.rb )
  spec.add_development_dependency('nokogiri')
end
