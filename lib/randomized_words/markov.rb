require 'securerandom'
require 'json'

module RandomizedWords
  class Markov
    TRAILER = " "

    def initialize(words:, letter_count:, min_length: nil, max_length: nil)
      @size = letter_count || 2
      @words = words.select {|w| w.size > @size}

      @starts = []
      @ngrams = {}

      @min_length = min_length
      @max_length = max_length

      generate_dictionary
    end

    def word()
      if @starts.empty? || @ngrams.empty?
        return ''
      end

      key = @starts.sample(random: SecureRandom)
      word = key
      target_length = get_target_length
      next_letter = @ngrams[key].sample(random: SecureRandom)

      if target_length
        while next_letter == TRAILER
          key = @starts.sample(random: SecureRandom)
          next_letter = key.chars.last
        end
      end

      loop do
        word += next_letter
        key = key[1, key.size] + next_letter

        next_grams = @ngrams[key]
        while next_grams.nil?
          # dead end, start fresh
          key = @starts.sample(random: SecureRandom)
          next_grams = @ngrams[key]
        end
        next_letter = next_grams.sample(random: SecureRandom)

        if target_length
          if word.size >= target_length
            break
          end

          while next_letter == TRAILER
            key = @starts.sample(random: SecureRandom)
            next_letter = key.chars.last
          end
        elsif next_letter == TRAILER
          break
        end
      end

      word
    end

    private

    def tuples(word)
      if word.size < @size - 1
        return
      end

      # ending for every word
      word = word + TRAILER

      (word.size - @size).times do |n|
        #     group           letter following group
        yield word[n, @size], word[n + @size]
      end
    end

    def generate_dictionary
      @words.each do |word|
        @starts << word[0, @size]

        tuples(word) do |key, next_letter|
          if @ngrams.has_key? key
            @ngrams[key] << next_letter
          else
            @ngrams[key] = [next_letter]
          end
        end
      end
    end

    def get_target_length
      if !@min_length.nil? && !@max_length.nil?
        (rand() * (@max_length - @min_length)).ceil + @min_length
      elsif !@min_length.nil?
        (rand() * @min_length).ceil + @min_length
      elsif !@max_length.nil?
        @max_length - (rand() * 3).floor
      end
    end
  end
end
