require 'ruby2d'

BEGIN{
    require 'ruby2d'

    # set up window
    set title: "Frogger"
    set width: 640
    set height: 600
    set background: 'green'
    
    #Create a hash table for usernames as the key and scores as the value 
    # We can use a timer to calculate scores 
    # create hash table for usernames and scores
    user_scores = {}
    # ask user for username and store in hash table
    #username = puts("Please enter your username:")
    #user_scores[username] = 0

    # Starting grass patch for frog
    grass = Rectangle.new(x: 0, y: 550, width: 640, height: 50, color: 'green')
    # Road for cars
    road = Rectangle.new(x: 0, y: 350, width: 640, height: 75, color: 'black')
    # Road 2
    road = Rectangle.new(x: 0, y: 200, width: 640, height: 75, color: 'black')

    # create movable frog sprite
    # Png used from pngWing
    frog = Sprite.new(
    'frog.png',
    x: 300,
    y: 550,
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
    4.times do |i|
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

}

# Main begins after BEGIN Block
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
            frog.y -= 25 if frog.y > 0
            sleep(0.1)
        end
    when 'down'
        Thread.new do
            frog.y += 25 if frog.y < (600 - frog.height)
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

    if bottom1-20 < top2 || top1+20 > bottom2 || right1 < left2 || left1 > right2
        return false
    else
        return true
    end
end


timeStart = Time.new
puts "Current time:" + timeStart.inspect

# start game loop
game_over = false
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

    game_over = false
   # while (game_over != true) do
  
        # check for collisions with logs
        logs.each do |log|
            if collides_with?(frog,log)
                puts "inside collision with log"
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
    #end

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

  # check if frog is in water without a log
  #if frog.y < 250 && !on_log
  #  set title: "Game Over"
    #pause
  #end

  #break if game_over

end

# show window
show
