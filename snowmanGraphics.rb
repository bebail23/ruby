require 'ruby2d'
# Variable declarations
guessedLetters = []
numberOfLetters = []
wrongLetters = []
duplicate = false
letterInWord = false
wordGuessed = false
numberOfGuesses = 6;


# Title and welcome message
set title: "Snowman", background: 'blue'
Text.new("Welcome to Snowman")

correctWord = File.readlines("dictionary.txt").sample
correctWord = correctWord.chomp
correctWord = correctWord.downcase
for i in 0..correctWord.length-1
    numberOfLetters.push("_ ")
end
for i in 0...numberOfLetters.length
    underscores = Text.new(
        numberOfLetters[i],
        x: 10 + i*20, y: 50 
)
end

letterBank = Text.new(
    "Letter guesses:",
    x: 10, y: 100
)

on :key_up do |event|
    # All keyboard interaction
    letterInWord = false
    duplicate = false
    letterGuess = event.key
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
        for i in 0...numberOfLetters.length
            underscores = Text.new(
                numberOfLetters[i],
                x: 10 + i*20, y: 50 
        )
        end
        if letterInWord == false and duplicate == false
            numberOfGuesses = numberOfGuesses - 1
            wrongLetters.push(letterGuess)
            for i in 0...guessedLetters.length
                letters = Text.new(
                    wrongLetters[i],
                    x: 10 + i*20, y: 120
                )
            end
            puts("\n")
            puts("Sorry that letter is not in the word, you have " + numberOfGuesses.to_s + " guesses left.")
            if numberOfGuesses == 5
                head = Circle.new
                head.x = 500
                head.y = 120
                head.radius = 50
                head.color = 'white'
            end
            if numberOfGuesses == 4
                torso = Circle.new
                torso.x = 500
                torso.y = 200
                torso.radius = 70
                torso.color = 'white'
            end
            if numberOfGuesses == 3
                bottom = Circle.new
                bottom.x = 500
                bottom.y = 300
                bottom.radius = 90
                bottom.color = 'white'
            end
            if numberOfGuesses == 2
                eye1 = Circle.new
                eye1.x = 480
                eye1.y = 105
                eye1.radius = 5
                eye1.color = 'black'
                eye2 = Circle.new
                eye2.x = 515
                eye2.y = 105
                eye2.radius = 5
                eye2.color = 'black'
            end
            if numberOfGuesses == 1
                nose = Triangle.new
                nose.x1 = 490
                nose.y1 = 115
                nose.x2 = 490
                nose.y2 = 135
                nose.x3 = 530
                nose.y3 = 125
                nose.color = 'orange'
            end
            if numberOfGuesses == 0
                button1 = Circle.new
                button1.x = 500
                button1.y = 165
                button1.radius = 10
                button1.color = 'fuchsia'
                button2 = Circle.new
                button2.x = 500
                button2.y = 195
                button2.radius = 10
                button2.color = 'fuchsia'
                button3 = Circle.new
                button3.x = 500
                button3.y = 225
                button3.radius = 10
                button3.color = 'fuchsia'
                losingMessage = Text.new(
                    "Sorry, you lost the game. The correct word was " + correctWord + ".",
                    x: 0, y: 400
                )
            end  
        end
        # Check to see if user solved through letter guesses
        if (numberOfLetters.include? '_ ') == false
            winningMessage = Text.new(
                "Congratulations you won!",
                x: 0, y: 400
            )
            wordGuessed = true
        end
    else
        puts("Sorry that is not a valid guess.")
    end
  end

show