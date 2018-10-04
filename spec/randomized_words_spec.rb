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
end
