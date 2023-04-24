# Jessica Mott and Brooke Bailey 
# Original Program: frog.rb
# April 24 2023
# This is a game made with Ruby2D that requires the player to move a frog from the bottom of the screen to the top as quickly as possible. 
# However, there are different types of obstacles to traverse in order to make this possible. Time will run until the frog 
# reaches the top of the screen, so the player must win in order for the game to finish. 
# The time will be compared to a leaderboard of previous players with the three lowest times. 

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
            $retryButton.remove
            $retryText.remove
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
            end
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
                # Calculate time for hash table 
                $timeStart = Time.now
                puts "Current time:" + $timeStart.inspect
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
        height: 60
    )
    nextLog = Sprite.new(
        'log.png',
        x: 300,
        y: 60,
        width: 150,
        height: 60
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

    # create 4 cars
    # Cars will be placed at random y positions within 35 pixels of one another
    # png used from pngWing
    cars = []
    4.times do |i|
    cars << Sprite.new(
        'car.png',
        x: i * 150 + 50,
        y: 360 + rand(-35..35),
        width: 75,
        height: 50
    )
    end

    # create 5 cars
    # Cars will be placed at random y positions within 20 pixels of one another
    # png used from pngWing

    cars_two = []
    5.times do |i|
    cars_two << Sprite.new(
        'cartwo.png',
        x: i * 150 + 50,
        y: 200 + rand(-20..20),
        width: 75,
        height: 50
    )
    end

    # create 4 crocs
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


# handle movement using threading to allow diagonal movement 
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
  
# Collision detection function 
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
impact = Sound.new('impact.ogg')
win = Sound.new('win.wav')
chompFrog = Sound.new('chomp.mp3')

backgroundSong = Music.new('Space-jazz.mp3')
backgroundSong.play

# Sets initial log direction so they can bounce off screen
logDirection = :right
nextDirection = :right

# Start game loop, will loop until window is closed
# Boolean to make sure the leaderboard is only updated once inside of infinite update loop
leaderboardCheck = false
update do

    # Move the log across the screen
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

    # Move second log across the screen
    if nextDirection == :right
        nextLog.x += 3
        # If the log sprite goes off the right side of the screen, change direction to left
        if nextLog.x + nextLog.width > Window.width
            nextDirection = :left
        end
    else
        nextLog.x -= 3
        # If the log sprite goes off the left side of the screen, change direction to right
        if nextLog.x < 0
            nextDirection = :right
        end
    end

    # Uses ternary operator, :? , as a way to write if/else on a single line
    # Even index will move -2 to the left and Odd will move -3 to the right
    # This makes the cars move at different speeds
    # https://www.rubyguides.com/2019/10/ruby-ternary-operator/
    # move cars
    cars.each_with_index do |car, i|
        car.x += i.even? ? -2 : 3
        if car.x < -car.width
            car.x = 640
        elsif car.x > 640
            car.x = -car.width
        end
    end

    # move second set of cars
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
    on_log = false
    on_nextLog = false

    # Did the frog land on the log, if it did move the same as the log
    if collides_with?(frog,theLog)
        on_log = true
        frog.y = theLog.y
        frog.x += ((theLog.x+50) - frog.x)
    end

    # Did the frog land on the log, if it did move the same as the log
    if collides_with?(frog,nextLog)
        on_nextLog = true
        frog.y = nextLog.y
        frog.x += ((nextLog.x+50) - frog.x)
    end

    # Did the frog land in the river without being on the log, if it did back to start
    if collides_with?(frog,riverLog)
        if !on_log && !on_nextLog
            waterDeath.play
            frog.y = 550
            frog.x = 300
        end
    end

    # check for collisions with cars
    cars.each do |car|
        if collides_with?(frog,car)
            impact.play
            frog.y = 550
            frog.x = 300
        end
    end

    # check for collisions with second set of cars
    cars_two.each do |car|
        if collides_with?(frog,car)
            impact.play
            frog.y = 550
            frog.x = 300
        end
    end

    # check for collisions with crocs
    crocs.each do |croc|
        if collides_with?(frog,croc)
            chompFrog.play
            frog.y = 550
            frog.x = 300
        end
    end

    # check if frog has made it to the other side, update leaderboard and calculate time
    if frog.y < 30 and not leaderboardCheck
      win.play
      leaderboardCheck = true
      elapsed_time = Time.now - $timeStart
      puts "Elapsed time: #{elapsed_time} seconds"
      $userHash[$user] = elapsed_time
      $userHash = $userHash.sort_by{|_name, score| score.to_i}
      file = File.open("usernames.txt")
      File.write("usernames.txt", "", mode: "w")
      $userHash.each do|name, score|
          File.write("usernames.txt", name + " " + score.to_s + "\n", mode: "a")
      end
      leaderboardUserArray = []
      leaderboardScoreArray = []
      leaderCount = 0
      $userHash.each do|name, score|
        leaderboardUserArray[leaderCount] = name
        leaderboardScoreArray[leaderCount] = score.to_s
        leaderCount = leaderCount + 1
      end
      leaderboardBox = Rectangle.new(
        x: 0, y: 0,
        width: 640, height: 600,
        color: "blue",
        z: 20
      )
      leaderboardTitle = Text.new(
        "Leaderboard",
        x: 200, y: 50, z: 20, color: "white", size: 32
      )
      firstPlace = $userHash[0].join("   ")
      leaderboardFirst = Text.new(
        firstPlace,
        x: 200, y: 150, z: 20, color: "white", size: 22
      )
      secondPlace = $userHash[1].join("   ")
      leaderboardSecond = Text.new(
        secondPlace,
        x: 200, y: 200, z: 20, color: "white", size: 22
      )
      thirdPlace = $userHash[2].join("   ")
      leaderboardThird = Text.new(
        thirdPlace,
        x: 200, y: 250, z: 20, color: "white", size: 22
      )
      yourScoreText = Text.new(
        "Your score: " + elapsed_time.to_s,
        x: 200, y: 500, z: 20, color: "white", size: 22
      )
    end


end
# end of update loop

# show window
show

