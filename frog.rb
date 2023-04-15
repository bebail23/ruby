require 'ruby2d'

BEGIN{
    require 'ruby2d'
    # set up window
    set title: "Frogger"
    set width: 640
    set height: 600
    set background: 'green'
    $user = ""
    $backgroundBox = Rectangle.new(
        x: 0, y: 0,
        width: 640, height: 600,
        color: "green",
        z: 20
    )
    $userBox = Rectangle.new(
      x: 50, y: 50,
      width: 540, height: 300,
      color: 'white',
      z: 20
    )
    $pastPlayersText = Text.new(
      "Past Players",
      x: 70, y: 200, z: 20, color: "black", size: 20
    )
    $retryButton = Rectangle.new(
      x: 470, y: 280, 
      width: 100, height: 50,
      color: "yellow",
      z: 20
    )
    $retryText = Text.new(
      "Retry",
      x: 495, y: 290, z: 20, color: "white", size: 22
    )
    $enterText = Text.new(
      "Enter your username:",
      x: 70, y: 70, z: 20, color: "black", size: 20
    )  
    $rulesText = Text.new(
      "Username Requirements",
      x: 70, y: 110, z: 20, color: "black", size: 15
    )  
    $rule1Text = Text.new(
      "- at least 6 characters long",
      x: 72, y: 130, z: 20, color: "black", size: 15
    )  
    $rule2Text = Text.new(
      "- at least 1 number",
      x: 72, y: 150, z: 20, color: "black", size: 15
    )  
    $rule3Text = Text.new(
      "- all lowercase",
      x: 72, y: 170, z: 20, color: "black", size: 15
    )  
    $p1UserText = Text.new(
      " ",
      x: 270, y: 70, z: 20, color: "black", size: 20
    )
    
    # Define regular expression matching functions
    def contains_upper(str)
      str =~ /[A-Z]/
    end 
    
    def contains_lower(str)
      str =~ /[a-z]/
    end 
    
    def contains_number(str)
      str =~ /\d/
    end 
    
    def contains_space(str)
      str =~ /\s/
    end
    
    $userHash = Hash.new
    
    # Open saved usernames file
    file = File.open("usernames.txt")
    # For each line, store into the hash table
    # Made use of blocking here
    File.foreach("usernames.txt") { |line| $userHash[line.split(/\s/).first] = line.split(/\s/).last}
    $fileSize = File.size("usernames.txt")
    
    listOfPlayers = []
    listOfScores = []
    countPlayers = 0
    $userHash.each do|name, score|
      listOfPlayers[countPlayers] = name
      listOfScores[countPlayers] = $userHash[name]
      countPlayers = countPlayers + 1
    end 
    
    players = listOfPlayers.join(" ")
    
    $listOfPlayersText = Text.new(
      players,
      x: 70, y: 230, z: 20, color: "black", size: 15
    )
    
    def retryUsername()
      $p1UserText.text = ""
      $rule1Text.color = "black"
      $rule2Text.color = "black"
      $rule3Text.color = "black"
      username()
    end 
    
    def username()
      userLetters = []
      finalLetter = false
      on :key_down do |event|
        if (event.key.match?(/[0-9]/) or contains_lower(event.key)) and event.key.length == 1 and not finalLetter
          userLetters[userLetters.length] = event.key
        end
        if event.key == "return"
          finalLetter = true
        end
        if not finalLetter
          $p1UserText.text = userLetters.join
        end 
        if finalLetter
          $user = userLetters.join.chomp("return")
          if contains_number($user) and not contains_upper($user) and not contains_space($user) and $user.length > 6
            valid = true 
            found = false
            oldScore = "0";
            $userHash.each do|name, score|
              if $userHash.key?($user)
                  oldScore = $userHash[$user]
                  found = true
              end
            end
            if !found
              $userHash[$user] = 0;
              if($fileSize == 0)
                  File.write("usernames.txt", $user + " " + $userHash[$user].to_s, mode: "a")
              end
              if($fileSize > 0)
                  File.write("usernames.txt", "\n" + $user + " " + $userHash[$user].to_s, mode: "a")
              end
            end
            $playButton = Rectangle.new(
              x: 470, y: 280, 
              width: 100, height: 50,
              color: "green",
              z: 20
            )
            $playText = Text.new(
              "Play",
              x: 500, y: 290, z: 20, color: "white", size: 22
            )
            on :mouse_down do |event|
              if event.x >= 470 and event.x <= 570 and event.y >= 280 and event.y <= 330
                $userBox.remove
                $playText.remove
                $retryText.remove
                $rulesText.remove
                $rule1Text.remove
                $rule2Text.remove
                $rule3Text.remove
                $pastPlayersText.remove
                $listOfPlayersText.remove
                $playButton.remove
                $retryButton.remove
                $enterText.remove
                $p1UserText.remove
                $backgroundBox.remove
              end
          end
          else 
            valid = false
            if $user.length <= 6 
              $rule1Text.color = "red"
            end
            if not contains_number($user)
              $rule2Text.color = "red"
            end
          end
        end
      end
    end
    
    on :mouse_down do |event|
      if event.x >= 470 and event.x <= 570 and event.y >= 280 and event.y <= 330
        retryUsername()
      end
    end
    userLetters = []
    username()
}

#Start of main code 

    # Starting grass patch for frog
    grass = Rectangle.new(x: 0, y: 550, width: 640, height: 50, color: 'green')
    # River for crocs
    river = Rectangle.new(x: 0, y: 500, width: 640, height: 50, color: 'blue')
    # River for log
    riverLog = Rectangle.new(x: 0, y: 70, width: 640, height: 80, color: 'blue')
    # Road for cars
    road = Rectangle.new(x: 0, y: 350, width: 640, height: 75, color: 'black')
    # Road 2
    road = Rectangle.new(x: 0, y: 200, width: 640, height: 75, color: 'black')

    # Log for frog to land on to end game
    # Created our own png
    theLog = Sprite.new(
        'log.png',
        x: 0,
        y: 100,
        width: 150,
        height: 75
    )
    nextLog = Sprite.new(
        'log.png',
        x: 300,
        y: 65,
        width: 150,
        height: 75
    )

    # create movable frog sprite
    # Png used from pngWing
    frog = Sprite.new(
    'frog.png',
    x: 300,
    y: 550,
    width: 40,
    height: 40
    )

    # create cars
    # png used from pngWing
    cars = []
    #min_y = 25
    #max_y = 500
    4.times do |i|
    cars << Sprite.new(
        'car.png',
        x: i * 150 + 50,
        #y: (500 - (rand(get(:width)))),
        y: 360 + rand(-35..35),
        #y: rand(min_y..max_y),
        width: 75,
        height: 50
    )
    end

    # create cars
    # png used from pngWing
    cars_two = []
    #min_y = 25
    #max_y = 500
    5.times do |i|
    cars_two << Sprite.new(
        'cartwo.png',
        x: i * 150 + 50,
        #y: (500 - (rand(get(:width)))),
        y: 200 + rand(-20..20),
        #y: rand(min_y..max_y),
        width: 75,
        height: 50
    )
    end

    # create crocs
    # From pngWing
    crocs = []
    4.times do |i|
    crocs << Sprite.new(
        'croc.png',
        x: i * 150 + 50,
        y: 475,
        width: 75,
        height: 90
    )
    end

# Calculate time for hash table 
timeStart = Time.new
puts "Current time:" + timeStart.inspect

# handle movement
on :key_down do |event|
    case event.key
    when 'left'
        Thread.new do
            frog.x -= 25 if frog.x > 0
            sleep(0.1)
        end
    when 'right'
        Thread.new do
            frog.x += 25 if frog.x < (640 - frog.width)
            sleep(0.1)
        end
    when 'up'
        Thread.new do
            frog.y -= 30 if frog.y > 0
            sleep(0.1)
        end
    when 'down'
        Thread.new do
            frog.y += 30 if frog.y < (600 - frog.height)
            sleep(0.1)
        end
    end
end
  
  
def collides_with?(sprite1, sprite2)
    left1 = sprite1.x
    right1 = sprite1.x + sprite1.width
    top1 = sprite1.y
    bottom1 = sprite1.y + (sprite1.height)

    left2 = sprite2.x
    right2 = sprite2.x + sprite2.width
    top2 = sprite2.y
    bottom2 = sprite2.y + (sprite2.height)

    if bottom1-20 < top2 || top1+25 > bottom2 || right1 < left2 || left1 > right2
        return false
    else
        return true
    end
end

# Sound effects!
waterDeath = Sound.new('splash.mp3')

# Sets initial log direction so they can bounce off screen
logDirection = :right

logBlock{

}

# start game loop
game_over = false
update do

    if logDirection == :right
        theLog.x += 2
        # If the log sprite goes off the right side of the screen, change direction to left
        if theLog.x + theLog.width > Window.width
            logDirection = :left
        end
    else
        theLog.x -= 2
        # If the log sprite goes off the left side of the screen, change direction to right
        if theLog.x < 0
            logDirection = :right
        end
    end

    # move cars
    cars.each_with_index do |car, i|
        car.x += i.even? ? -2 : 3
        if car.x < -car.width
            car.x = 640
        elsif car.x > 640
            car.x = -car.width
        end
    end

    # move cars
    cars_two.each_with_index do |car, i|
        car.x += i.even? ? -2 : 2
        if car.x < -car.width
        car.x = 640
        elsif car.x > 640
        car.x = -car.width
        end
    end

    # move crocs
    crocs.each_with_index do |croc, i|
        croc.x += i.even? ? -2 : 2
        if croc.x < -croc.width
            croc.x = 640
        elsif croc.x > 640
            croc.x = -croc.width
        end
    end

    # Collision checking
    game_over = false
    on_log = false

    # Did the frog land on the log, if it did move the same as the log
    if collides_with?(frog,theLog)
        on_log = true
        frog.x += ((theLog.x+50) - frog.x)
    end

     # Did the frog land in the river without being on the log, if it did back to start
    if collides_with?(frog,riverLog)
        puts "landed in river"
        if !on_log
            waterDeath.play
            frog.y = 550
            frog.x = 300
            game_over = true
        end
    end

    # check for collisions with cars
    cars.each do |car|
        if collides_with?(frog,car)
            puts "inside collision with car"
            frog.y = 550
            frog.x = 300
            game_over = true
        end
    end

    # check for collisions with cars
    cars_two.each do |car|
        if collides_with?(frog,car)
            puts "inside collision with car"
            frog.y = 550
            frog.x = 300
            game_over = true
        end
    end

    # check for collisions with cars
    crocs.each do |croc|
        if collides_with?(frog,croc)
            puts "inside collision with croc"
            frog.y = 550
            frog.x = 300
            game_over = true
        end
    end


    # Check if a collision occured and 
    if game_over == true 
        #loser = Rectangle.new(x: 300, y: 440, width: 80, height: 30, color: 'green')
        #Text.new('You lost!', x: 310, y: 440, size: 20)
        puts "gameOver"
    end

  # check if frog has made it to the other side
  if frog.y < 100
    set title: "You Win!"
    #pause
  end


end
# end of update loop

# show window
show
