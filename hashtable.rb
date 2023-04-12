# https://www.thoughtco.com/how-to-create-hashes-2908196
# https://www.rubyguides.com/2015/06/ruby-regex/ 
# https://stackoverflow.com/questions/7523916/return-string-until-matched-string-in-ruby
# https://launchschool.com/books/ruby/read/hashes

# Create hash table for usernames and scores
$userHash = Hash.new
free = false
newUsername = ""

# Open saved usernames file
file = File.open("usernames.txt")
# For each line, store into the hash table
File.foreach("usernames.txt") { |line| $userHash[line.split(/\s/).first] = line.split(/\s/).last}
$fileSize = File.size("usernames.txt")

# Define regular expression matching functions
def contains_upper(str)
    str =~ /[A-Z]/
  end 
  
def contains_number(str)
    str =~ /\d/
end 

def contains_space(str)
    str =~ /\s/
end

# Function to get username from user
def getUsername()
  # Ask for username 
  puts("Enter your username (6 characters long with 1+ uppercase letters, 1+ numbers, and no spaces): ")
  newUsername = gets 
  newUsername = newUsername.chomp
  return newUsername
end

# Function to check if given username meets requirements
def userValid(user)
  valid = false
  # Check to see if username matches requirements
  if contains_number(user) and contains_upper(user) and not contains_space(user) and user.length > 6
    valid = true 
  end
  while(valid == false)
    puts("INVALID: Enter your username (6 characters long with 1+ uppercase letters, 1+ number, and no spaces): ")
    user = gets 
    user = user.chomp
    if contains_number(user) and contains_upper(user) and not contains_space(user) and user.length > 6
      valid = true 
    end
  end
  return valid
end

# Function to check to see if username is free
def userFree(user)
  free = false
  $userHash.each do|name, score|
      if not $userHash.key?(user)
          free = true
      end
  end
  return free
end

# Function to add user to hash table 
def addUser(user)
  $userHash[user] = 0;
  if($fileSize == 0)
      File.write("usernames.txt", user + " " + $userHash[user].to_s, mode: "a")
  end
  if($fileSize > 0)
      File.write("usernames.txt", "\n" + user + " " + $userHash[user].to_s, mode: "a")
  end
end

# Get username, check if valid, and check if free 
newUsername = getUsername();
if userValid(newUsername)
  free = userFree(newUsername)
end

# If the username is free, add to hash. Else, keep asking user for username until valid and free one is found.
if(free or $fileSize == 0)
  addUser(newUsername)
else
    while not free
      puts("Sorry that username is taken. Please try another one.")
      newUsername = getUsername()
      if userValid(newUsername)
        free = userFree(newUsername)
      end
    end
    addUser(newUsername)
end
file.close

$userHash.each do|name,score|
    puts "#{name}: #{score}"
end
