local GameState = {}
local Turret = require('model/Turret')
local newCamera = require('model/Camera')
local MapGenerator = require('model/MapGenerator2')
GRAVITY = 1.81
SCREEN_W = 1280
SCREEN_H = 864
-- SCREEN_H = 600
BLOCKSIZE = 16
MAP_SCALE = 3
MAP_WIDTH = 250
MAP_HEIGHT = 100
SCREEN_BLOCK_W = SCREEN_W / (BLOCKSIZE * MAP_SCALE)
SCREEN_BLOCK_H = SCREEN_H / (BLOCKSIZE * MAP_SCALE)
OCTAVE = 7
AMPLITUDE = 32
DEBUG = false
CAMERA = newCamera(1280/2, SCREEN_H / 2, 5, 0.5)
MAP = nil

local gravitySlider = {value = 1.81, min = -20, max = 20}
local bulletMassSlider = {value = 100, min = 0, max = 500}
local turretPowerSlider = {value = 500, min = 0, max = 2000}
-- Called once, and only once, before entering the state the first time. See Gamestate.switch().
function GameState:init()
  -- print('SCREEN_BLOCK_W: '..SCREEN_BLOCK_W)
  -- print('SCREEN_BLOCK_H: '..SCREEN_BLOCK_H)
  self.tiles = {}
  self.tiles[1] = love.graphics.newQuad(1*16, 2*16, 16, 16, ASSET.tilesAtlas:getDimensions())
  self.tiles[2] = love.graphics.newQuad(1*16, 1*16, 16, 16, ASSET.tilesAtlas:getDimensions())
  self.generator = MapGenerator()
  -- 1660643569
  --self.map = self.generator:generate(MAP_WIDTH, OCTAVE, AMPLITUDE, 1660643569)
  MAP = self.generator:generate(MAP_WIDTH, OCTAVE, AMPLITUDE)
  -- print(#self.map)
  -- print(self.map[0].height)
  self.turret1 = Turret()
  print((MAP[2].height))
  self.turret1:init(2 * BLOCKSIZE * MAP_SCALE , ((MAP[2].height + 0) * BLOCKSIZE * MAP_SCALE) - 58, 0, 500)
  --CAMERA = Camera(1280/2, SCREEN_H / 2)
  CAMERA.x = 1280 / 2
  CAMERA.y = self.turret1.y
  --self.running = true

end

--Called every time when entering the state. See Gamestate.switch().
function GameState:enter(previous)
  MAP = self.generator:generate(MAP_WIDTH, OCTAVE, AMPLITUDE)
  -- print(#self.map)
  -- print(self.map[0].height)
  self.turret1 = Turret()
  self.turret1:init(2 * BLOCKSIZE * MAP_SCALE ,((MAP[2].height + 0) * BLOCKSIZE * MAP_SCALE) - 58, 0, 500)
  CAMERA.x = 1280 / 2
  CAMERA.y = self.turret1.y
end

--Called when leaving a state. See Gamestate.switch() and Gamestate.pop().
function GameState:leave()
end

--Called when re-entering a state by Gamestate.pop()-ing another state.
function GameState:resume()
end

function GameState:update(dt)
    Lovebird:update()
    self.turret1:update(dt)
    -- SUIT.layout:reset(0,SCREEN_H, 20,20)


    if CAMERA.shake then
      CAMERA.time = CAMERA.time + dt
      CAMERA.x = CAMERA.x + (CAMERA.mag * math.sin(CAMERA.time * 20 * 2))
      CAMERA.y =  CAMERA.y + (CAMERA.mag * math.sin(CAMERA.time * 20))
      if CAMERA.time >= CAMERA.shakeTime then
        CAMERA.time = 0
        CAMERA.shake = false
      end
    end
    
    SUIT.Label(tostring('GRAVITY'), 10, 700 + 14 , 200,20)
    if SUIT.Slider(gravitySlider, 10 ,700 + 30, 200,20).hit then GRAVITY = gravitySlider.value end
    SUIT.Label(tostring(gravitySlider.value), 10, 700 + 30 + 14 , 200,20)

    SUIT.Label(tostring('BULLET_MASS'), 10, 700 + 30 + 14 + 14 , 200,20)
    if SUIT.Slider(bulletMassSlider, 10 ,700 + 30 + 14 + 14+14, 200,20).hit then self.turret1.bulletMass = bulletMassSlider.value end
    SUIT.Label(tostring(bulletMassSlider.value), 10, 700 + 30 + 14 + 14+14 + 14 , 200,20)

    SUIT.Label(tostring('TURRET_POWER'), 10,800 , 500,20)
    if SUIT.Slider(turretPowerSlider, 10 ,800+14, 500,20).hit then self.turret1.power = turretPowerSlider.value end
    SUIT.Label(tostring(turretPowerSlider.value), 10, 800 + 30, 500,20)
    -- SUIT.Label('GRAVITY', 10, 10 + 14 , 200,20)
  --CAMERA.x = self.turret1.x
  --CAMERA.y = self.turret1.y
end

function GameState:draw()
  local startX = math.floor((CAMERA.x  / (BLOCKSIZE * MAP_SCALE) - (SCREEN_BLOCK_W / 2) ) )
  local endX = startX + SCREEN_BLOCK_W

  local startY = math.floor(CAMERA.y  / (BLOCKSIZE * MAP_SCALE) - (SCREEN_BLOCK_H / 2) )
  local endY = startY + SCREEN_BLOCK_H

  startX = math.max(0,startX-1)
  endX = math.min(#MAP, endX+1)

  startY = math.max(0,startY-1)
  endY = math.min(#MAP[0],endY+1)




  CAMERA:attach()
  for x=startX,endX do
    for y=startY,endY do
      if MAP[x][y] ~= nil then
        --love.graphics.rectangle('fill', (x) * BLOCKSIZE, (y) * BLOCKSIZE, BLOCKSIZE, BLOCKSIZE )
        love.graphics.draw(ASSET.tilesAtlas, self.tiles[MAP[x][y]], (x) * BLOCKSIZE * MAP_SCALE, (y) * BLOCKSIZE * MAP_SCALE, 0, MAP_SCALE, MAP_SCALE)
        --print(MAP[x][y])
        end
    end
  end

  self.turret1:draw()
  CAMERA:detach()
  local r, g, b, a = love.graphics.getColor() 
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle('fill', 0, 700, SCREEN_W, SCREEN_H - 700)
  love.graphics.setColor(r, g, b, a)

  SUIT.draw()
  for x=0,#MAP - 1 do
    for y=0,#MAP[x] - 1 do
      if MAP[x][y] ~= nil then
        love.graphics.rectangle('fill', (x*3) + SCREEN_W - MAP_WIDTH * 3 , ((y*3) + 700 - MAP_HEIGHT) ,3, 3 )
        -- print(x ,y + 200)
        -- love.graphics.draw(ASSET.tilesAtlas, self.tiles[MAP[x][y]], (x) * BLOCKSIZE * MAP_SCALE, (y) * BLOCKSIZE * MAP_SCALE, 0, MAP_SCALE, MAP_SCALE)
        --print(MAP[x][y])
        end
    end
  end
end

--Called if the window gets or loses focus.
function GameState:focus()
end

function GameState:keypressed(key, code)
  if key == 'escape' then GS.switch(MenuState) end
  if key == 'up' then
    self.turret1:moveCanonUp()
  end
  if key == 'down' then
    self.turret1:moveCanonDown()
  end
  if key == 'left' then
  end
  if key == 'right' then
  end
  if key == 'z' then
    CAMERA.y = CAMERA.y - BLOCKSIZE  * MAP_SCALE
  end
  if key == 's' then
    CAMERA.y = CAMERA.y + BLOCKSIZE  * MAP_SCALE
  end
  if key == 'q' then
    CAMERA.x = CAMERA.x - BLOCKSIZE  * MAP_SCALE
  end
  if key == 'd' then
    CAMERA.x = CAMERA.x + BLOCKSIZE  * MAP_SCALE
  end
  if key == 'space' then
    self.turret1:fire()
  end
  if key == 'g' then
    MAP = self.generator:generate(MAP_WIDTH, OCTAVE, AMPLITUDE)
    self.turret1:init(2 * BLOCKSIZE * MAP_SCALE ,((MAP[2].height + 0) * BLOCKSIZE * MAP_SCALE) - 58, 0, 500)
    CAMERA.y = self.turret1.y
  end
end

function GameState:keyreleased()
end

function GameState:mousepressed(x, y, button, istouch, presses)
  print('x:'..x)
  print('y:'..y)
end

function GameState:mousereleased()
end

function GameState:joystickpressed()
end

function GameState:joystickreleased()
end

function GameState:quit()
end

return GameState
