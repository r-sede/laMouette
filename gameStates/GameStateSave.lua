local GameState = {}
local turret = {}
turret.x, turret.y = 0, 0
turret.angle = 0
local bullets = {}
local couille = {}
couille.x=0
couille.y=0
couille.angle = 0
local BULLET_MASS = 200
local PATATE = 1500

-- Called once, and only once, before entering the state the first time. See Gamestate.switch().
function GameState:init()
  -- self.player = {}
  -- self.player.x = 0
  -- self.player.y = 0
  -- self.camera = Camera(self.player.x, self.player.y)
  self.turret = love.graphics.newImage('assets/turret1-big.png');
  self.canon =  love.graphics.newImage('assets/canon.png');
end

--Called every time when entering the state. See Gamestate.switch().
function GameState:enter(previous)
end

--Called when leaving a state. See Gamestate.switch() and Gamestate.pop().
function GameState:leave()
end

--Called when re-entering a state by Gamestate.pop()-ing another state.
function GameState:resume()
end

function GameState:update(dt)
  for i=1,#bullets do
    -- bullets[i].x =  bullets[i].x + (bullets[i].speed * math.cos(bullets[i].angle)) * dt
    -- bullets[i].y =  bullets[i].y + (bullets[i].speed * math.sin(bullets[i].angle)) * dt


    bullets[i].speedY = bullets[i].speedY + bullets[i].mass * 9.81 * dt

    bullets[i].x =  bullets[i].x + bullets[i].speedX * dt
    bullets[i].y =  bullets[i].y + bullets[i].speedY * dt
    if bullets[i].x > 800 or bullets[i].x < 0 or bullets[i].y > 600 then bullets[i].shoulDie = true end
    --Lovebird.print('x:  '..bullets[i].x)
    --Lovebird.print('Vely:  '..bullets[i].speedY)
  end
  for i=#bullets,1, -1 do
    if bullets[i].shoulDie then table.remove(bullets, i) end
  end
end

function GameState:draw()
  love.graphics.draw(self.canon, turret.x + 50, turret.y + 13 + 8, turret.angle, 1, 1, 0, 8)
  love.graphics.draw(self.turret, turret.x, turret.y)
  love.graphics.print('angle: '..turret.angle, 300, 0)
  -- love.graphics.print('BULLET_MASS : '..#bullets, 500, 0)
  love.graphics.print('BULLET_MASS : '..BULLET_MASS, 500, 0)
  love.graphics.print('PATATE : '..PATATE, 500, 14)
  -- love.graphics.circle( 'fill', couille.x, couille.y, 3)
  for i=1,#bullets do
    love.graphics.circle( 'fill', bullets[i].x, bullets[i].y, 3)
  end
end

--Called if the window gets or loses focus.
function GameState:focus()
end

function GameState:keypressed(key, code)
  if key == 'escape' then GS.switch(MenuState) end
  if key == 'up' then
    -- couille.y = couille.y - 1
    -- couille.angle = couille.angle - 0.05
    turret.angle = turret.angle - 0.05
  end
  if key == 'down' then
    -- couille.y = couille.y + 1
    -- couille.angle = couille.angle + 0.05
    turret.angle = turret.angle + 0.05
  end
  if key == 'left' then
    PATATE = PATATE - 100
    -- couille.x = couille.x - 1
    -- turret.angle = turret.angle - 0.05
  end
  if key == 'right' then
    PATATE = PATATE + 100
    -- couille.x = couille.x + 1
    -- turret.angle = turret.angle + 0.05
  end
  if key == 'z' then
    BULLET_MASS = BULLET_MASS + 50
    -- couille.x = couille.x - 1
    -- turret.angle = turret.angle - 0.05
  end
  if key == 's' then
    BULLET_MASS = BULLET_MASS - 50
    -- couille.x = couille.x + 1
    -- turret.angle = turret.angle + 0.05
  end
  if key == 'space' then fire() end
  turret.angle = Lume.clamp(turret.angle,-1.45, 0.45)
  couille.x = (turret.x + 50) + 53 * math.cos(turret.angle)
  couille.y = (turret.y + 1.5*13) + 53 * math.sin(turret.angle)
end

function GameState:keyreleased()
end

function GameState:mousepressed()
end

function GameState:mousereleased()
end

function GameState:joystickpressed()
end

function GameState:joystickreleased()
end

function GameState:quit()
end

function fire()
  local bullet = {}
  bullet.angle = turret.angle
  bullet.x = couille.x
  bullet.y = couille.y
  bullet.speed = PATATE
  bullet.speedX =  PATATE * math.cos(turret.angle)
  bullet.speedY = PATATE * math.sin(turret.angle)
  bullet.mass = BULLET_MASS
  table.insert(bullets, bullet)
end


return GameState
