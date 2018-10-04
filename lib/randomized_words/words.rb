require 'randomized_words/markov'

module RandomizedWords
  class Words
    def initialize(words=nil, letter_count=nil, min_length=nil, max_length=nil)
      if words.nil?
        path = File.join File.dirname(__FILE__), 'data', 'latin_words.txt'
        words = self.class.parse_file(path)
      end

      @markov = Markov.new(words: words, letter_count: letter_count, min_length: min_length, max_length: max_length)
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
      "<RandomizedWords::Words #{self.object_id}>"
    end

    def inspect
      self.to_s
    end

    def word
      @markov.word
    end
  end
end
