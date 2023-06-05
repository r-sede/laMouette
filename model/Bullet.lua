local Bullet = {}

function Bullet.init(this, x, y, angle, mass, power)
    this.x = x or 0
    this.y = y or 0
    this.angle = angle or 0
    this.power = power or 1500
    this.mass = mass or 250
    this.velX = power * math.cos(this.angle)
    this.velY = power * math.sin(this.angle)
    this.shouldDie = false

end

function Bullet.update(this, dt)
    --apply force
    --Lovebird.print('x '..this.x)
    --Lovebird.print('y '..this.y)
    --Lovebird.print('angle '..this.angle)
    --Lovebird.print('power '..this.power)
    --Lovebird.print('mass '..this.mass)
    --Lovebird.print('velX '..this.velX)
    --Lovebird.print('velY '..this.velY)
    --Lovebird.print(this.shouldDie)

    this.velY = this.velY + this.mass * 9.81 * dt
    this.x =  this.x + this.velX * dt
    this.y =  this.y + this.velY * dt
    if this.x > 800 or this.x < 0 or this.y > 600 then this.shouldDie = true end
end

function Bullet.draw(this)
    love.graphics.circle( 'fill', this.x, this.y, 3)
end

return Bullet