require 'ruby2d'

# Define constants for the game window size and font
WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480
FONT_SIZE = 32

# Set up the game window
set title: "Snowman", width: WINDOW_WIDTH, height: WINDOW_HEIGHT

# Snowman body dimensions
SNOWMAN_RADIUS_1 = 60
SNOWMAN_RADIUS_2 = 40
SNOWMAN_RADIUS_3 = 20

# Snowman parts colors
SNOWMAN_COLOR = 'white'
HAT_COLOR = 'black'
SCARF_COLOR = 'red'
BUTTON_COLOR = 'black'

# Snowman parts
body = Circle.new(
    x: WINDOW_WIDTH / 2, 
    y: WINDOW_HEIGHT - SNOWMAN_RADIUS_1 - SNOWMAN_RADIUS_2 - SNOWMAN_RADIUS_3, 
    radius: SNOWMAN_RADIUS_1, 
    sectors: 32, 
    color: SNOWMAN_COLOR)

head = Circle.new(
    x: WINDOW_WIDTH / 2, 
    y: WINDOW_HEIGHT - SNOWMAN_RADIUS_1 - SNOWMAN_RADIUS_2, 
    radius: SNOWMAN_RADIUS_2, 
    sectors: 32, 
    color: SNOWMAN_COLOR)
nose = Triangle.new(
    x1: WINDOW_WIDTH / 2 - SNOWMAN_RADIUS_3 / 2, 
    y1: WINDOW_HEIGHT - SNOWMAN_RADIUS_1 - SNOWMAN_RADIUS_2 + SNOWMAN_RADIUS_3 / 2, 
    x2: WINDOW_WIDTH / 2 + SNOWMAN_RADIUS_3 / 2, 
    y2: WINDOW_HEIGHT - SNOWMAN_RADIUS_1 - SNOWMAN_RADIUS_2 + SNOWMAN_RADIUS_3 / 2, 
    x3: WINDOW_WIDTH / 2, 
    y3: WINDOW_HEIGHT - SNOWMAN_RADIUS_1 - SNOWMAN_RADIUS_2 - SNOWMAN_RADIUS_3 / 2, 
    color: 'orange')
hat = Rectangle.new(
    x: WINDOW_WIDTH / 2 - SNOWMAN_RADIUS_2 / 2, 
    y: WINDOW_HEIGHT - SNOWMAN_RADIUS_1 - SNOWMAN_RADIUS_2 - SNOWMAN_RADIUS_3 - SNOWMAN_RADIUS_2 / 2, 
    width: SNOWMAN_RADIUS_2, 
    height: SNOWMAN_RADIUS_2 / 2, 
    color: HAT_COLOR)
scarf = Rectangle.new(
    x: WINDOW_WIDTH / 2 - SNOWMAN_RADIUS_2 / 2, 
    y: WINDOW_HEIGHT - SNOWMAN_RADIUS_1 - SNOWMAN_RADIUS_2 + SNOWMAN_RADIUS_3, 
    width: SNOWMAN_RADIUS_2, 
    height: SNOWMAN_RADIUS_2 / 4, 
    color: SCARF_COLOR)
button_1 = Circle.new(
    x: WINDOW_WIDTH / 2, 
    y: WINDOW_HEIGHT - SNOWMAN_RADIUS_1 - SNOWMAN_RADIUS_2 / 2, 
    radius: SNOWMAN_RADIUS_3 / 2, 
    sectors: 32, 
    color: BUTTON_COLOR)
button_2 = Circle.new(
    x: WINDOW_WIDTH / 2, 
    y: WINDOW_HEIGHT - SNOWMAN_RADIUS_1, 
    radius: SNOWMAN_RADIUS_3 / 2, 
    sectors: 32, 
    color: BUTTON_COLOR)


# Variable declarations
guessedLetters = []
numberOfLetters = []
duplicate = false
letterInWord = false
wordGuessed = false
numberOfGuesses = 6;
# Hard-coded words for game
# words = ["cat", "dog", "turtle", "elephant", "bird", "ant", "lizard", "frog", "bear", "lion"]

# Game randomly selects one of the file words to use and print underscores 
correctWord = File.readlines("dictionary.txt").sample
correctWord = correctWord.chomp
puts(correctWord)
correctWord = correctWord.downcase
for i in 0..correctWord.length-1
    numberOfLetters.push("_ ")
end
for i in 0..correctWord.length-1
    print(numberOfLetters[i])
end

 
# While user still has guesses left and user hasn't won, keep asking for guesses 
while numberOfGuesses > 0 and wordGuessed == false
    # Asks for user input for their letter guess and add to array of already guessed letters
    puts("\n")
    puts("\n")
    if guessedLetters.length > 0
        guessedLetters = guessedLetters.sort
        puts("Your previous letter guesses: " + guessedLetters.to_s)
    end
    puts("Guess a letter ")
    letterGuess = gets 
    letterGuess = letterGuess.chomp
    letterGuess = letterGuess.downcase
    if letterGuess.match(/[a-z]/) or letterGuess == "," or letterGuess == "-" or letterGuess == "'"
        # Check if letter is a duplicate
        if guessedLetters.length > 0
            for i in 0..correctWord.length-1
                if letterGuess == guessedLetters[i]
                    duplicate = true
                end
            end
        end
        # If guess is duplicate, display error message
        # Else, add letter to array
        if duplicate == true
            puts("Sorry that is a duplicate guess")
        else 
            guessedLetters.push(letterGuess)
        end

        # If letter in word, save in correct spot of underscored word 
        for i in 0..correctWord.length-1
            if letterGuess == correctWord[i]
                numberOfLetters[i] = letterGuess
                letterInWord = true
            end
        end

        # Display updated underscored word 
        for i in 0..correctWord.length-1
            print(numberOfLetters[i])
        end

        # If letter not in word, decrement number of guesses remaining and display message
        if letterInWord == false and duplicate == false
            numberOfGuesses = numberOfGuesses - 1
            puts("\n")
            puts("Sorry that letter is not in the word, you have " + numberOfGuesses.to_s + " guesses left.")
            head.add if numberOfGuesses <= 5
            body.add if numberOfGuesses <= 4
            nose.add if numberOfGuesses <= 3
            hat.add if numberOfGuesses <= 2
            button_1.add if numberOfGuesses <= 1
            button_2.add if numberOfGuesses <= 0
        end

    # Check if user has any remaining guesses
    if numberOfGuesses == 0
        puts("Sorry, you lost the game. The correct word was " + correctWord + ".")
        head.add
        body.add
        nose.add
        hat.add
        button_1.add
        button_2.add
        break
    end

        # Check to see if user solved through letter guesses
        if (numberOfLetters.include? '_ ') == false
            puts("\n")
            puts("Congratulations you won the game! The correct word was " + correctWord + ".")
            wordGuessed = true
            break
        end

        # Asks user if they would like to solve
        if duplicate == false
            puts("\n")
            puts("Would you like to solve the word? (y/n)")
            solve = gets
            solve = solve.chomp
            # If user wants to solve, ask for guess
            if solve ==  "y"
                puts("Please enter your guess: ")
                userGuess = gets
                userGuess = userGuess.chomp
                # If user solves correctly, end game and show congratulations message
                if userGuess == correctWord 
                    puts("Congratulations you won the game! The correct word was " + correctWord + ".")
                    wordGuessed = true  
                # If user solves incorrectly, decrement number of guesses and show message 
                else
                    numberOfGuesses = numberOfGuesses - 1
                    puts("Sorry, that is not the correct word. You have " + numberOfGuesses.to_s + " guesses left.")
                end
            end
        end
    else
        puts("Sorry that is not a valid guess. Please try again.")
    end
    # Reset variables to false for next iteration
    duplicate = false
    letterInWord = false
end