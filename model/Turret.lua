local Mouette = require('model/Mouette')

local init = function(this, x, y, angle, power, canonMoveSpeed)
  this.x = x or 0
  this.y = y or 0
  this.power = power or 1500
  this.canon = {}
  this.canon.moveSpeed = canonMoveSpeed or 0.05
  this.canon.angleMaxUp = -1.45
  this.canon.angleMaxDown = 0.45
  this.canon.angle = angle or 0
  this.canon.x = this.x + 50
  this.canon.y = this.y + 13 + 8
  this.bullets = {}
  this.emitPointX = 0
  this.emitPointY = 0
  this.bulletMass = 100
  this:_updateEmitPoint()
end

local draw = function(this)
  love.graphics.draw(ASSET.canon, this.canon.x, this.canon.y, this.canon.angle, 1, 1, 0, 8)
  love.graphics.draw(ASSET.turret, this.x, this.y)

  for i=1,#this.bullets do
    this.bullets[i]:draw()
  end
  --love.graphics.circle( 'fill', this.emitPointX, this.emitPointY, 3)
end

local moveCanonUp = function(this)
  this.canon.angle = this.canon.angle - this.canon.moveSpeed
  this.canon.angle = Lume.clamp(this.canon.angle, this.canon.angleMaxUp, this.canon.angleMaxDown)
  this:_updateEmitPoint()
end

local moveCanonDown = function(this)
  this.canon.angle = this.canon.angle + this.canon.moveSpeed
  this.canon.angle = Lume.clamp(this.canon.angle, this.canon.angleMaxUp, this.canon.angleMaxDown)
  this:_updateEmitPoint()
end

local update = function(this, dt)
  for i=1, #this.bullets do
    this.bullets[i]:update(dt)
  end

  for i=#this.bullets,1, -1 do
    if this.bullets[i].shouldDie then table.remove(this.bullets, i) end
  end
end

local _updateEmitPoint = function(this)
  this.emitPointX = ( this.x + 50 ) + 53 * math.cos(this.canon.angle)
  this.emitPointY = ( this.y + 1.5*13 ) + 53 * math.sin(this.canon.angle)
end

local fire = function(this)
  local mouette = Mouette()
  mouette:init(this.emitPointX, this.emitPointY, this.canon.angle, this.bulletMass, this.power)
  print(this.bulletMass)
  table.insert(this.bullets, mouette)
  local rnd = love.math.random(1,2)
  Lovebird.print(rnd)
  ASSET.mouettesSound[rnd]:play()
end

local create = function()
  local turret = {}
  turret.init = init
  turret.draw = draw
  turret.moveCanonUp = moveCanonUp
  turret.moveCanonDown = moveCanonDown
  turret.update = update
  turret._updateEmitPoint = _updateEmitPoint
  turret.fire = fire
  return turret
end

return create