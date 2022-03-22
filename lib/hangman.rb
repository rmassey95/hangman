def check_word(word)
  if word.length < 5 || word.length > 12
    return false
  else
    return true
  end
end

word_file = File.open('google-10000-english-no-swears.txt', 'r')

all_words = word_file.readlines
good_word = false

until good_word do
  word = all_words[Random.rand(0..10000)].chomp
  good_word = check_word(word)
end

word_file.close