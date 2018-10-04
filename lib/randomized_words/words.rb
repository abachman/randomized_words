require 'randomized_words/markov'

module RandomizedWords
  class Words
    attr_reader :words, :letter_count, :min_length, :max_length

    def initialize(words=nil, letter_count=nil, min_length=nil, max_length=nil)
      @words = words
      @letter_count = letter_count
      @min_length = min_length
      @max_length = max_length

      if @words.nil?
        path = File.join File.dirname(__FILE__), 'data', 'latin_words.txt'
        @words = self.class.parse_file(path)
      end

      @markov = Markov.new(words: @words, letter_count: @letter_count, min_length: @min_length, max_length: @max_length)
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
