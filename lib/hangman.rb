class Game
  attr_accessor :word, :guesses, :display, :incorrect_guesses, :correct_guesses, :trys

  def initialize(guesses={},display="",word="",incorrect_guesses=[],correct_guesses=[], trys=1)
    @guesses = guesses
    @display = display
    @guess = ""
    @incorrect_guesses = incorrect_guesses
    @correct_guesses = correct_guesses
    @trys = trys
    @word = word
  end
  public

  def player_guess()
    while true do
      puts "Enter a letter or type save to 'save' progress: "
      @guess = gets.chomp.downcase
      if @guesses.keys.include?(@guess) || @guess != 'save' && @guess.length > 1
        next
      else
        break
      end
    end
    if @guess == 'save'
      save_game()
    else
      return check_guess()
    end
  end

  def get_new_word(all_words)
    good_word = false
    until good_word do
      @word = all_words[Random.rand(0..10000)].chomp
      good_word = check_word(word)
    end
    @display = "_"*@word.length
  end

  def check_win()
    if @guesses.values.sum == @word.length
      puts "YOU GOT THE WORD! IT WAS #{@word}"
      return true
    else
      return false
    end
  end

  private

  def save_game()
    puts "What would you like to call the file? "
    fname = gets.chomp
    save = File.open("./saved_games/#{fname}.txt", 'w')
    save.puts @guesses
    save.puts @display
    save.puts @word
    save.puts @incorrect_guesses.join('')
    save.puts @correct_guesses.join('')
    save.puts @trys
    save.close
    exit
  end

  def check_guess()
    if @word.include?(@guess)
      @word.split('').each_index do |index|
        if @word[index] == @guess
          @display[index] = @guess
          if @guesses[@guess] == nil
            @correct_guesses.push(@guess)
            @guesses[@guess] = 1
          else
            @guesses[@guess] += 1
          end
        end
      end
      return true
    else
      @incorrect_guesses.push(@guess)
      @guesses[@guess] = 0
      return false
    end
  end

  def check_word(word)
    if word.length < 5 || word.length > 12
      return false
    else
      return true
    end
  end
end

word_file = File.open('google-10000-english-no-swears.txt', 'r')
all_words = word_file.readlines

puts "Type 'load' to load a saved game or 'new' to run a new game"
choice = gets.chomp

if choice == 'load'
  puts "Saved Games: "
  Dir.each_child("./saved_games") do |fname|
    puts fname
  end
  puts "What file do you want to load? "
  fname = gets.chomp
  load_game = File.open("./saved_games/#{fname}.txt")
  guesses = eval(load_game.readline)
  display = load_game.readline.chomp
  word = load_game.readline.chomp
  incorrect_guesses = load_game.readline.chomp.split('')
  correct_guesses = load_game.readline.chomp.split('')
  trys = load_game.readline.to_i

  load_game.close

  game = Game.new(guesses, display, word, incorrect_guesses, correct_guesses, trys)
  puts game.word
  puts game.display
  puts "INCORRECT GUESSES: #{game.incorrect_guesses.join(' ')}"
  puts "CORRECT GUESSES: #{game.correct_guesses.join(' ')}"
else
  game = Game.new()
  game.get_new_word(all_words)
  puts game.word
end

while true do
  win = false

  while game.trys <= 6 do

    unless game.player_guess()
      game.trys += 1
    end

    puts "INCORRECT GUESSES: #{game.incorrect_guesses.join(' ')}"
    puts "CORRECT GUESSES: #{game.correct_guesses.join(' ')}"

    if game.check_win()
      win = true
      break
    end

    puts game.display

  end
  puts "YOU LOST! THE WORD WAS #{game.word}" unless win

  puts "Play Again? 'y' or 'n'"
  if (gets.chomp) == "n"
    break
  else  
    game = Game.new()
    game.get_new_word(all_words)
    puts game.word
  end
end

word_file.close