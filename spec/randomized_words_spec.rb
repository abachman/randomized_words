def short_word_list
  @short_word_list ||= begin
                         path = File.join File.dirname(__FILE__), 'spec', 'short_word_list.txt'
                         RandomizedWords::Words.parse_file(path)
                       end
end

RSpec.describe RandomizedWords do
  it "has a version number" do
    expect(RandomizedWords::VERSION).not_to be nil
  end

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
end
