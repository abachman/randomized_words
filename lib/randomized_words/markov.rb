require 'json'

# based on a Python sketch retrieved 2018-10-04 from: https://gist.github.com/Eckankar/360212
module RandomizedWords
  class Markov
    TRAILER = " "

    attr_reader :parent, :ngrams, :starts

    def initialize(words:, letter_count:, parent:, min_length: nil,
                   max_length: nil, cache: nil)
      @parent = parent
      @min_length = min_length
      @max_length = max_length

      if cache
        @starts = cache['starts']
        @ngrams = cache['ngrams']
      else
        @starts = []
        @ngrams = {}

        @size = letter_count || 2
        @words = words.select {|w| w.size > @size}

        generate_dictionary
      end
    end

    def word()
      if @starts.empty? || @ngrams.empty?
        return ''
      end

      key = @starts.sample(random: parent.random)
      word = key
      target_length = get_target_length
      next_letter = @ngrams[key].sample(random: parent.random)

      while next_letter == TRAILER
        key = @starts.sample(random: parent.random)
        next_letter = key.chars.last
      end

      loop do
        word += next_letter
        key = key[1, key.size] + next_letter

        next_grams = @ngrams[key]
        while next_grams.nil?
          # dead end, start fresh
          key = @starts.sample(random: parent.random)
          next_grams = @ngrams[key]
        end
        next_letter = next_grams.sample(random: parent.random)

        if target_length
          if word.size >= target_length
            break
          end

          while next_letter == TRAILER
            key = @starts.sample(random: parent.random)
            next_letter = key.chars.last
          end
        elsif next_letter == TRAILER
          break
        end
      end

      word
    end

    def dump_ngrams
      JSON.generate({
        starts: @starts,
        ngrams: @ngrams
      })
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
        (parent.random.rand() * (@max_length - @min_length)).ceil + @min_length
      elsif !@min_length.nil?
        (parent.random.rand() * @min_length).ceil + @min_length
      elsif !@max_length.nil?
        @max_length - (parent.random.rand() * 3).floor
      end
    end
  end
end
