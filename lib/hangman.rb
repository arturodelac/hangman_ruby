module Drawing
  @@head = "O"
  @@left_arm = "/"
  @@body = "|"
  @@right_arm = "\\"
  @@left_leg = "/"
  @@right_leg = "\\"

  @@parts_array = [@@head, @@left_arm, @@body, @@right_arm]
end

class Board
  include Drawing
  @list_of_words = []

  def draw_hangman
    #Draws the hangman from the body parts in Drawing module
    puts " " + @@parts_array[0] + " "
    puts @@parts_array[1] + @@parts_array[2] + @@parts_array[3]
    puts @@left_leg + " " + @@right_leg
  end
end

class Items < Board
  @array_char = []
  @@array_guess = []

  def start
    draw_hangman()
    @random_word = select_random_word()
    puts @random_word
    start_guess
  end

  def select_random_word
    @list_of_words = File.readlines("google-10000-english-no-swears.txt")
    random_word = @list_of_words[rand(@list_of_words.length - 1)]
    random_word
  end

  def start_guess
    @random_word = @random_word.chomp
    @array_char = @random_word.split("")
    (@array_char.length()).times do
      @@array_guess.push("_")
    end
    @@array_guess.each { |letter| print letter }
  end
end

class Game < Items
  def initialize
    start()
    #Loops game until the hangman dissapears
    while @@parts_array.include?("/") || @@parts_array.include?("O") || @@parts_array.include?("\\")
      turn
      #If the user guesses all the letters the loop breaks
      if @@array_guess.include?("_") == false
        break
      end
    end
  end

  def turn
    puts
    @user_input = gets.chomp
    ##Corrects user input if user inputs more than 1 letter
    if @user_input.length > 1
      @user_input = @user_input[0]
    end

    #Checks if the letter is included in the random word and then adds it to the guess array if true
    if @array_char.include?(@user_input)
      @array_char.each_with_index do |char, index|
        if char == @user_input
          @@array_guess[index] = @user_input
        end
      end
    else
      #Removes part from the hangman (needs fixing)
      @@parts_array[rand(@@parts_array.length - 1)] = " " if @@parts_array[rand(@@parts_array.length - 1)] != " "
    end
    #draws the updated hangman
    draw_hangman
    #Draws the guess
    @@array_guess.each { |letter| print letter }
  end
end

board = Game.new
