require 'securerandom'

module RandomizedWords
  module SeededRandom
    def seed=(value)
      if value.nil?
        @_random = nil
        return
      elsif value.is_a?(String)
        if /\A[a-fA-F0-9]+\z/ =~ value
          # if it looks like a hex string, treat it like hex
          value = value.to_i(16)
        else
          # treat strings as a base255 number
          sum = 0
          value.chars.reverse.each_with_index do |c, i|
            sum += (c.bytes[0] * 255 ** i)
          end
          value = sum
        end
      end

      @_random = Random.new(value.to_i)

      return
    end

    def seed
      @seed
    end

    def has_seed?
      !@seed.nil?
    end

    def random
      @_random || SecureRandom
    end
  end
end
