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
trys = 1
win = false

guesses = Hash.new
until good_word do
  word = all_words[Random.rand(0..10000)].chomp
  good_word = check_word(word)
end

puts word

display = "_"*word.length

incorrect_guesses = Array.new()
correct_guesses = Array.new()

while trys <= 6 do

  puts "Enter a letter: "
  guess = gets.chomp

  if word.include?(guess)
    word.split('').each_index do |index|
      if word[index] == guess
        display[index] = guess
        if guesses[guess] == nil
          guesses[guess] = 1
        else
          guesses[guess] += 1
        end
      end
    end
  else
    trys += 1
    guesses[guess] = 0
  end

  if guesses[guess] > 0
    correct_guesses.push(guess)
  else
    incorrect_guesses.push(guess)
  end

  puts "INCORRECT GUESSES: #{incorrect_guesses}"
  puts "CORRECT GUESSES: #{correct_guesses}"

  if guesses.values.sum == word.length
    puts "WIN"
    win = true
    break
  else
    puts "NOT"
  end
  puts display

end

if win
  puts "YOU GOT THE WORD! IT WAS #{word}"
else
  puts "YOU DIDN'T GET THE WORD"
end

word_file.close