require 'json'
require 'randomized_words/markov'
require 'randomized_words/seeded_random'

module RandomizedWords
  class Words
    include SeededRandom

    attr_reader :words, :letter_count, :min_length, :max_length

    def initialize(words=nil, letter_count=nil, min_length=nil, max_length=nil)
      @words = words
      @letter_count = letter_count
      @min_length = min_length
      @max_length = max_length

      @cache = nil

      if @words.nil?
        if @letter_count.nil? || @letter_count == 2
          require 'json'
          path = File.join File.dirname(__FILE__), 'data', 'latin_2_ngrams.json'
          @cache = JSON.parse open(path).read()
          @words = []
        else
          path = File.join File.dirname(__FILE__), 'data', 'latin_words.txt'
          @words = self.class.parse_file(path)
        end
      end

      @markov = Markov.new(words: @words, letter_count: @letter_count,
                           min_length: @min_length, max_length: @max_length,
                           cache: @cache, parent: self)
    end

    def self.parse_file(word_file_path)
      open(word_file_path).read().
        downcase.
        gsub(/[^a-z]/,' ').
        split(/\s/).
        map(&:strip).
        sort.
        uniq.
        select {|w| w.size > 0}
    end

    def dump_ngrams
      @markov.dump_ngrams
    end

    def to_s
      "<RandomizedWords::Words words=(#{words.size} items) letter_count=#{letter_count.inspect} min_length=#{min_length.inspect} max_length=#{max_length.inspect}>"
    end

    def inspect
      self.to_s
    end

    def word
      @markov.word
    end
  end
end
