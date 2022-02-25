module Drawing
  @@head = "O"
  @@left_arm = "/"
  @@body = "|"
  @@right_arm = "\\"
  @@left_leg = "/"
  @@right_leg = "\\"

  @@parts_array = [@@head, @@left_arm, @@body, @@right_arm,@@left_leg,@@right_leg]

  def redraw
  @@head = "O"
  @@left_arm = "/"
  @@body = "|"
  @@right_arm = "\\"
  @@left_leg = "/"
  @@right_leg = "\\"
  @@parts_array = [@@head, @@left_arm, @@body, @@right_arm,@@left_leg,@@right_leg]
  end
end

class Board
  include Drawing
  @list_of_words = []

  def draw_hangman
    #Draws the hangman from the body parts in Drawing module
    puts " " + @@parts_array[0] + " "
    puts @@parts_array[1] + @@parts_array[2] + @@parts_array[3]
    puts @@parts_array[4] + " " + @@parts_array[5]
  end
end

class Items < Board
  @array_char = []
  @@array_guess = []

  def start
    draw_hangman()
    @random_word = select_random_word()
    #puts @random_word
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
    @counter = -1
    game_steps
  end

  def game_steps
    start()
    game_loop
    play_again
  end

  def play_again
    puts "","The word was #{@random_word}!"
    puts "Do you want to play again? Y/N"
    user_answer = gets.chomp.downcase
    user_answer = user_answer[0]
    @array_char = []
    @@array_guess = []
    redraw
    @counter = -1
    if user_answer == "y"
      game_steps
    else
      puts "Thanks for playing!"
    end
  end

  def game_loop
    #Loops game until the hangman dissapears
    while @@parts_array.include?("/") || @@parts_array.include?("O") || @@parts_array.include?("\\")
      turn()
      #If the user guesses all the letters the loop breaks
      if @@array_guess.include?("_") == false
        puts "", "You win!!!"
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
      @counter += 1
      #Removes part from the hangman
      @@parts_array[@counter] = " "
    end
    #draws the updated hangman
    draw_hangman
    #Draws the guess
    @@array_guess.each { |letter| print letter }
  end
end

board = Game.new
