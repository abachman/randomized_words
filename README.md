# RandomizedWords

Uses the Markov chain generation technique to generate new nonsense words based on a given word list. If no word list is specified, this library uses a Latin word list as seed data. **NOTE:** no effort is made to prevent specific words from appearing in the output, so if you use a word list that contains "swear" words, you are likely to get swear words in the output.

There are many libraries like it, but this one is mine.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'randomized_words'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install randomized_words

## Usage

From Ruby:

```
>> require 'randomized_words'
>> gen = RandomizedWords::Words.new
=> <RandomizedWords::Words words=(3713 items) letter_count=nil min_length=nil max_length=nil>
>> 5.times { puts gen.word }
favia
tromistia
spalista
vens
ose
```

Can also be used from the command line with the `randomized_words` command.

```
$ gem install randomized_words
$ randomized_words -w 10 --min 3 --max 12 -f $HOME/Documents/Books/the-enchirdion-of-epictetus__the-manual.txt
diat
accultso
immouldhin
purtiever
wictiontsods
poverpea
oppril
tiou
anglenta
marelyvl
```

`RandomizedWords::Words.new` accepts up to four arguments:

```ruby
require 'randomized_words'

words = RandomizedWords::Words.parse_file('/usr/share/dict/words')
letter_count = 2
min_length = 3
max_length = 10

generator = RandomizedWords::Words.new words, letter_count, min_length, max_length
puts generator
# => <RandomizedWords::Words words=(234369 items) letter_count=2 min_length=3 max_length=10>
20.times { puts generator.word }
# => rectualit
# => inscaterne
# => psemi
# => pegaloke
# => urag
# => monan
# => fletrismp
# => semonona
# => raystop
# => agerr
# => being
# => pautendwyh
# => foramin
# => curartic
# => mentemolde
# => sepogra
# => painalif
# => vapidykem
# => quinont
# => welyasgi
```

All arguments are optional.

* `words` is an array of strings. You can use `RandomizedWords::Words.parse_file` to generate a useable word list from a file path.
* `letter_count` is the length of strings to consider when generating "next steps" for the Markov chain. (the ngram size)
* `min_length` and `max_length` are the minimum and maximum length of generated words.

When given min length or max length values, this library won't exclusively use the Markov chain generation methodology so longer words may "restart" in the middle. Other than that, everything that comes out should look like it could be in the original word list.

`RandomizedWords::Words.parse_file` takes a file path as an argument and returns an Array of words with spaces, numbers, and punctuation taken out.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/abachman/randomized_words. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

`mnemonic_word_list.txt` is taken from https://gist.github.com/fogleman/c4a1f69f34c7e8a00da8 by [github.com/fogelman](https://github.com/fogelman).

## Code of Conduct

Everyone interacting in the RandomizedWords project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/abachman/randomized_words/blob/master/CODE_OF_CONDUCT.md).
