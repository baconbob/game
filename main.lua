
local rotation = 0
local accerelation = 0
local x = 0
local y = 0
local buttons = {"quit", "exit MENU"}
local buttons_1 = {"quit","try again"}
local invertspin = false
local width
local height
local x1 = 50
local y1 = 50
local sfx
local speed = 2
local mouse
local Enemy = require "Enemy"
local enemies = {}
local seconds = 0
local fraction = 1/10
local object_to_main =  {}
local Vector_2 = require "Vector_2"
local enemies_x
local enemies_y
local hp = 100
local mainchar_size1
local mainchar_size2
local mainchar_diameter = 49
local enemy_heigt = 100
local enemy_width = 50
local state = not love.mouse.isVisible()
local state_vis = love.mouse.isVisible()
local coins = 1

-- FUNCTIONS
function resetgame (args)
  hp = 100
  for i = 1, #enemies do --showing enemies
    enemies[i] = nil
  end
  love.graphics.draw(mainchar, x1, y1, 0, 0.035, 0.035)
  accerelation = 0
end



function love.draw() -- adding character, pictures and texts
  love.graphics.draw(eft, 0, 0, r, 1, 1)
  love.graphics.draw(mario,1530,70, rotation, 2, 2)
  love.graphics.print("the accerelation; " .. accerelation, 10, 37.5)
  love.graphics.setBackgroundColor(10,100, 100, 255)
  --if accerelation > 50
  --then love.graphics.draw(GABEN, (width/2), (height/2), -rotation, 0.5, 0.5)
  --end
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 12.5)
  love.graphics.draw(mainchar, x1, y1, 0, 0.035 , 0.035)
  love.graphics.print("Current speed:" .. speed,10,25)
  love.graphics.print("Current position x:" .. x1 .. " \nCurrent position y:" .. y1,10,50)
  love.graphics.print("Current healthpoints:" .. hp,10,80)

  for i = 1, #enemies do --showing enemies
	enemies[i]:draw()
	end
end

function love.update(dt)
  math.randomseed(os.time())
  local random_number = math.random(0, 40)
  seconds = seconds + dt
  if seconds >= 1 -- every second an enemy is spawned
  then
    if random_number <= 10 then enemies_x = 10 enemies_y = 30
    elseif random_number <= 20 then enemies_x = 10 enemies_y = 780
    elseif random_number <= 30 then enemies_x = 1580 enemies_y = 30
    else enemies_x = 1580 enemies_y = 780
    end
    enemies[#enemies+1] = Enemy.new(GABEEN,enemies_x, enemies_y)
	  seconds = 0  end
  if invertspin then
    rotation = rotation + math.rad(accerelation)
  else
    rotation = rotation - math.rad(accerelation)
  end
  accerelation = accerelation + 0.0025

  y = love.mouse.getY()
  x = love.mouse.getX()
  if love.keyboard.isDown("w") then y1 = y1 - speed end
  if love.keyboard.isDown("a") then x1 = x1 - speed end
  if love.keyboard.isDown("s") then y1 = y1 + speed end
  if love.keyboard.isDown("d") then x1 = x1 + speed end
  if x1+mainchar_diameter>width then x1=width-mainchar_diameter end
  if y1+mainchar_diameter>height then y1=height-mainchar_diameter end
  if y1<0 then y1=0 end
  if x1<0 then x1=0 end
  --[[for i,v in ipairs(enemies) do
    object_to_main.x = x1 - v.x
    object_to_main.y = y1 - v.y
    v.x = v.x +(object_to_main.x* 0.1)
    v.y = v.y +(object_to_main.y* 0.1)
  end]] --THIS IS THE SHIT FOR COIN= POINTS
  for k,v in pairs(enemies) do
    v:update()
    v:move_to(Vector_2.new(x1,y1))
    --if v:intersects{x = x,y = y,w = enemy_width, h =enemy_heigt} then hp = 100-10 end
    if v.x == x1 then hp = hp -10 end
  end
  --for shape, delta in pairs(collider:collisions(ball)) do
--    shape:move(delta.x, delta.y)
if speed > 2 then
 speed = speed * 0.996
 else speed = 2
 end
 if hp <= 0 then gameover = love.window.showMessageBox("YOU LOSE, rush B next time pls", "try again or quit this shit?",buttons_1)
   if gameover == 1 then love.event.quit()
   elseif gameover == 2 then resetgame() end
 end
 end


function love.load()
  mario = love.graphics.newImage("tracking-dot.png")
  GABEEN = love.graphics.newImage("enemoy.png")
  love.window.setMode(0, 0,{fullscreen=true,vsync=false})
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  eft = love.graphics.newImage("space.jpg")
  imageData = love.graphics.newImage("cursor.png")
  cursor = love.mouse.newCursor( imageData:getData(), 5, 5 )
  love.mouse.setCursor(cursor)
  mainchar = love.graphics.newImage("Russia_flag.PNG")
  sfx = love.audio.newSource("xplosion.wav","stream")
  love.physics.setMeter(64)
  love.mouse.setVisible(state)
  width2, height2 = imageData:getDimensions()
end

function love.keypressed(key)
  if key == "r" then
    speed=accerelation
    accerelation = 0
    print (speed)
  end
  if key == "escape" then
    local buttonpressed = love.window.showMessageBox("MENU", "What do you want to do blyat", buttons)
    if buttonpressed == 1 then love.event.quit()
    elseif buttonpressed == 2 then end
  end
  if key == "t" then invertspin=not invertspin end
  if key == "q" then sfx:play() end

end

-- to do list: enemies cant collide, enemies can collide on an pixel of main character,fix sound when deaded,
--fix coins, whenever the character die- show stats!-
