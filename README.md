# Subber

[![Build Status](https://travis-ci.org/viki-org/subber-gem.svg?branch=master)](https://travis-ci.org/viki-org/subber-gem)

This is the Subber gem from Viki. This gem helps you convert subtitles from SRT to VTT and vice versa.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'subber'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install subber

## Usage

```rb
# Ways to instantiate a `Subber::File::Srt` or `Subber::File::Vtt`
#
srt_file = Subber::File::Srt.from_content("pass file content here")
srt_file = Subber::File::Srt.from_path("pass local or remote file path here")
srt_file = Subber::File::Srt.new(Array<Subber::Subtitle>)

# Read the content of the file
#
srt_file.content

# Get Subber::Subtitle objects
#
srt_file.subtitles

# Export to a local file
#
srt_file.export("pass local path here")

# Convert between Srt and Vtt
#
vtt_file = srt_file.to_vtt
srt_file = vtt_file.to_srt
```

## Development

### Add a new file type

Do replace `NewType` and `new_type` with corresponding values

- [ ] Add `Subber::File::NewType`
- [ ] Add `to_new_type` to other `Subber::File` files
- [ ] Add `Subber::Formatted::NewType`
- [ ] Add `Subber::Parser::NewType`
- [ ] Update `Subber::File::Base#to_file_type`
- [ ] Update `Subber::File.from_content`


After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/viki-org/subber-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
