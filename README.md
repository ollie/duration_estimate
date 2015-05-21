# DurationEstimate [![Build Status](https://img.shields.io/travis/ollie/duration_estimate/master.svg)](https://travis-ci.org/ollie/duration_estimate) [![Code Climate](https://img.shields.io/codeclimate/github/ollie/duration_estimate.svg)](https://codeclimate.com/github/ollie/duration_estimate) [![Gem Version](https://img.shields.io/gem/v/duration_estimate.svg)](https://rubygems.org/gems/duration_estimate)

Do something to a collection of items and see how long it is going to take.
Useful for long-running Rake tasks.

## Usage

```ruby
items = 0..10000 # Some data set.

DurationEstimate.each(items) do |item, e|
  print "\r#{ DurationEstimate::TerminalFormatter.format(e) }"

  # Do something time consuming with item.
  sleep 0.001
end

puts
```

You can specify the collection size if you are using some kind of ORM that
does not respond to `:size` method.

```ruby
media = Media
  .where { created_at > Time.parse('some time') }
  .order(:created_at)

File.open('missing-media.log', 'w') do |log|
  DurationEstimate.each(media, size: media.count) do |medium, e|
    print "\r#{ DurationEstimate::TerminalFormatter.format(e) }"

    unless medium.on_s3?
      log.puts medium.id
      log.fsync # Write changes now, be able tail the file.
    end

    sleep 2 # Don't overload AWS S3
  end
end

puts
```

This is going to re-print a line with something like this:

     1/11 (  9.09 %) -, -
     2/11 ( 18.18 %) 11:47:29, 00:00:34
     3/11 ( 27.27 %) 11:47:30, 00:00:31
     4/11 ( 36.36 %) 11:47:31, 00:00:27
     5/11 ( 45.45 %) 11:47:31, 00:00:23
     6/11 ( 54.55 %) 11:47:30, 00:00:19
     7/11 ( 63.64 %) 11:47:30, 00:00:15
     8/11 ( 72.73 %) 11:47:30, 00:00:11
     9/11 ( 81.82 %) 11:47:30, 00:00:07
    10/11 ( 90.91 %) 11:47:30, 00:00:03
    11/11 (100.00 %) 11:47:30, 00:00:00

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'duration_estimate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install duration_estimate

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it (https://github.com/ollie/duration_estimate/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
