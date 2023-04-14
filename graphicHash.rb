require 'ruby2d'

# set up window
set title: "Frogger Username"
set width: 640
set height: 600
set background: 'blue'
$user = ""
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
show
