# Ruby4Misawa

## About

A scraping library for 地獄のミサワ

This is not compatible with old version.

## Installation

add this line to your Gemfile.

`gem 'Ruby4Misawa'`

or

`$ gem install Ruby4Misawa`

## Usage

### cid

```ruby
require 'Ruby4Misawa'

misawa = Misawa.new(32)
misawa.scrape ##> [{ :image => ..., :title => ..., :date => ..., :identifier => ..., :body => ... }, ...]
```

### name

```ruby
require 'Ruby4Misawa'

misawa = Misawa.new("あつしさん")
misawa.scrape ##> [{ :image => ..., :title => ..., :date => ..., :identifier => ..., :body => ... }, ...]
```

### designating page numebr

```ruby
require 'Ruby4Misawa'

misawa = Misawa.new("あつしさん", 2)
misawa.scrape ##> [{ :image => ..., :title => ..., :date => ..., :identifier => ..., :body => ... }, ...]
```

## Contributing

1. fork the project.
2. create your feature branch. (`git checkout -b my-feature`)
3. commit your changes. (`git commit -am 'commit message.'`)
4. push to the branch. (`git push origin my-feature`)
5. send pull request.

## License

MIT
