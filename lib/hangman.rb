word_file = File.open('google-10000-english-no-swears.txt', 'r')

all_words = word_file.readlines

puts all_words[Random.rand(0..10000)]



word_file.close