require 'json'

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

  def start_guess_with_save
    @@array_guess.each { |letter| print letter }
  end
end

class Game < Items


  def initialize
    @exit=0
    @counter = -1
    game_steps
  end

  def game_steps
    if load_save == "n"
    start()
    else
    draw_hangman()
    start_guess_with_save
    end
    game_loop
    if @exit ==0
    play_again
    end
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
        puts "You win!!!"
        @exit=0
        break
      elsif @exit==1
        break
      else 
        @exit = 0
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
    #checks for input to save

    if @user_input == "9"
      to_json
      puts  "Saved. Thanks for playing!"
      @exit = 1
    else 
      @exit=0
    


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
    #Asks to save 
    puts "","Enter guess or 9 to save"
  end
  end

  def to_json
   File.write("save.json", (JSON.dump ({
      :array_char => @array_char,
      :array_guess => @@array_guess,
      :parts_array => @@parts_array,
      :random_word => @random_word,
      :counter => @counter
   })))
  end

  def from_json
    data =JSON.load File.read("save.json") 
    @array_char = data["array_char"]
    @@array_guess = data["array_guess"]
    @@parts_array = data["parts_array"]
    @random_word = data["random_word"]
    @counter = data["counter"]
  end

  def load_save
    puts "Do you want to load a save?"
    user_answer =gets.chomp
    user_answer = user_answer[0].downcase
    if user_answer == "y"
      from_json
    end
    user_answer
  end
end

board = Game.new
