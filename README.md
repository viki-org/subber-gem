# Subber

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
# Instantiate a Subber::Srt or Subber::Vtt object
#
srt = Subber::Srt.new("<local-file-path-or-remote-url>")

# Read the content of the file
#
srt.content

# Get Subber::Subtitle objects
#
srt.subtitles

# Get raw exportable content
srt.vtt_content

# Convert to other file formats
#
srt.to_vtt("<destination>")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/viki-org/subber-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Subber project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/viki-org/subber-gem/blob/master/CODE_OF_CONDUCT.md).
