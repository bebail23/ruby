require 'ruby2d'

# set up window
set title: "Frogger"
set width: 640
set height: 480
set background: 'blue'

#Create a hash table for usernames as the key and scores as the value 
# We can use a timer to calculate scores 

# create frog sprite
# Png used from pngWing
frog = Sprite.new(
  'frog.png',
  x: 300,
  y: 400,
  width: 40,
  height: 40
)

# create logs
# Created our own log png 
logs = []
4.times do |i|
  logs << Sprite.new(
    'log.png',
    x: i * 150 + 50,
    y: 200,
    width: 150,
    height: 50
  )
end

# create cars
# png used from pngWing
cars = []
4.times do |i|
  cars << Sprite.new(
    'car.png',
    x: i * 150 + 50,
    y: 350,
    width: 75,
    height: 50
  )
end

# handle movement
on :key_held do |event|
  case event.key
  when 'left'
    frog.x -= 5 if frog.x > 0
  when 'right'
    frog.x += 5 if frog.x < (640 - frog.width)
  when 'up'
    frog.y -= 5 if frog.y > 0
  when 'down'
    frog.y += 5 if frog.y < (480 - frog.height)
  end
end

# start game loop
update do
  # move logs
  logs.each_with_index do |log, i|
    log.x += i.even? ? 2 : -2
    if log.x < -log.width
      log.x = 640
    elsif log.x > 640
      log.x = -log.width
    end
  end

  # move cars
  cars.each_with_index do |car, i|
    car.x += i.even? ? -3 : 3
    if car.x < -car.width
      car.x = 640
    elsif car.x > 640
      car.x = -car.width
    end
  end

  # check for collisions with logs
  # need to make .collides_with? method
  on_log = false
  #logs.each do |log|
    #if frog.collides_with? log
      #on_log = true
      #frog.x += log.x_velocity
    #end
  #end

  # check for collisions with cars
  #on_car = false
  #cars.each do |car|
    #if frog.collides_with? car
      #set title: "Game Over"
      #pause
    #end
  #end

  # check if frog has made it to the other side
  if frog.y < 100
    set title: "You Win!"
    pause
  end

  # check if frog is in water without a log
  if frog.y < 250 && !on_log
    set title: "Game Over"
    pause
  end
end

# show window
show
