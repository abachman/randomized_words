def fixture_file(name)
  File.join File.dirname(__FILE__), 'fixtures', name
end

def short_word_list
  @short_word_list ||= begin
                         path = fixture_file 'short_word_list.txt'
                         RandomizedWords::Words.parse_file(path)
                       end
end

RSpec.describe RandomizedWords do
  it "has a version number" do
    expect(RandomizedWords::VERSION).not_to be nil
  end

  describe RandomizedWords::Words do
    it "generates words with default word list and length" do
      gen = RandomizedWords::Words.new
      word = gen.word
      expect(word).not_to eq(nil)
    end

    it "generates words given a word list" do
      gen = RandomizedWords::Words.new(@short_word_list)
      word = gen.word
      expect(word).not_to eq(nil)
    end

    it "generates words with options" do
      gen = RandomizedWords::Words.new(nil, 3, 4, 8)

      100.times do |w|
        word = gen.word
        expect(word).not_to eq(nil)
        expect(word.size).to be_between(4, 8)
      end
    end

    it "parses a story into a word list" do
      word_list = RandomizedWords::Words.parse_file(fixture_file('short_story.txt'))
      word_list.each do |word|
        expect(word).not_to match(/[\s\d]/)
      end
    end

    it "supports seeded randomness" do
      gen_1 = RandomizedWords::Words.new(@short_word_list)
      gen_2 = RandomizedWords::Words.new(@short_word_list)
      gen_3 = RandomizedWords::Words.new(@short_word_list)

      gen_1.seed = "asdf"
      gen_2.seed = "asdf"

      a = gen_1.word
      b = gen_1.word
      c = gen_1.word

      expect(a).not_to be(b)
      expect(b).not_to be(c)
      expect(a).not_to be(c)

      expect(a).to eq(gen_2.word)
      expect(b).to eq(gen_2.word)
      expect(c).to eq(gen_2.word)

      # NOTE: this test should always work, but we're playing with randomness, so these tests may occasionally fail
      expect(a).not_to eq(gen_3.word)
      expect(b).not_to eq(gen_3.word)
      expect(c).not_to eq(gen_3.word)
    end
  end

  describe RandomizedWords::Colors do
    it "supports seeded randomness" do
      gen_1 = RandomizedWords::Colors.new
      gen_2 = RandomizedWords::Colors.new
      gen_3 = RandomizedWords::Colors.new

      gen_1.seed = "asdf"
      gen_2.seed = "asdf"

      a = gen_1.hex
      b = gen_1.hex
      c = gen_1.hex

      expect(a).not_to be(b)
      expect(b).not_to be(c)
      expect(a).not_to be(c)

      expect(a).to eq(gen_2.hex)
      expect(b).to eq(gen_2.hex)
      expect(c).to eq(gen_2.hex)

      # NOTE: this test should always work, but we're playing with randomness, so these tests may occasionally fail
      expect(a).not_to eq(gen_3.hex)
      expect(b).not_to eq(gen_3.hex)
      expect(c).not_to eq(gen_3.hex)
    end

    it "generates color names" do
      gen = RandomizedWords::Colors.new
      expect(gen.name).not_to be_nil
      expect(gen.name).to match(/[a-z]+/)
    end

    it "generates rgb" do
      gen = RandomizedWords::Colors.new
      expect(gen.rgb).to match(/\d{1,3},\d{1,3}\d{1,3}/)
    end

    it "generates hsl" do
      gen = RandomizedWords::Colors.new
      expect(gen.hsl).to match(/\d{1,3},\d{1,3}\d{1,3}/)
    end

    it "generates hex" do
      gen = RandomizedWords::Colors.new
      expect(gen.hex).to match(/[A-F0-9]{6}/)
    end
  end
end
