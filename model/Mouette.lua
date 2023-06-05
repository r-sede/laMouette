
local init = function(this, x, y, angle, mass, power)
    this.x = x or 0
    this.y = y or 0
    this.angle = angle or 0
    this.power = power or 1500
    this.mass = mass or 250
    this.velX = power * math.cos(this.angle)
    this.velY = power * math.sin(this.angle)
    this.shouldDie = false
    this.keyframe = 1
    this.fps = 10
    this.dirX = 0
    this.drawScale = 2
    this.animTimer = 1 /this.fps
    this.sprites = {}
    this.sprites['fly'] = {
        love.graphics.newQuad(0*20,0,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(1*20,0,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(2*20,0,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(3*20,0,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(0*20,1*20,20,20, ASSET.mouettesAtlas:getDimensions()),
    }
    this.sprites['explode'] = {
        love.graphics.newQuad(0*20,2*20,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(1*20,2*20,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(2*20,2*20,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(3*20,2*20,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(4*20,2*20,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(5*20,2*20,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(6*20,2*20,20,20, ASSET.mouettesAtlas:getDimensions()),
        love.graphics.newQuad(7*20,2*20,20,20, ASSET.mouettesAtlas:getDimensions()),
    }
    this.animState = 'fly'
    this.nbrFrame = #this.sprites[this.animState]
    this.collBox = {
        x = this.x - (20*this.drawScale*0.5),
        y = this.y - (20*this.drawScale*0.5),
        width = 20*this.drawScale,
        height = 20*this.drawScale,
    }

end

local setAnimState = function(this, state)
    if state == 'fly' or state == 'explode' then
        this.animState = state
        this.keyframe = 1
        this.nbrFrame = #this.sprites[this.animState]
    end
end

local update = function(this, dt)

    if this.velX > 0 then this.dirX = 1 else this.dirX = -1 end

    this:animate(dt)

    this.velY = this.velY + (this.mass * GRAVITY) * dt
    -- this.velX = this.velX + this.mass * -0.5 * dt
    this.x =  this.x + this.velX * dt
    this.y =  this.y + this.velY * dt

    this.angle = math.atan2(  this.velY, this.velX )

    this.collBox = {
        x = this.x - (20*this.drawScale*0.5),
        y = this.y - (20*this.drawScale*0.5),
        width = 20*this.drawScale,
        height = 20*this.drawScale,
    }


    local mapX = Lume.clamp(Lume.round(this.collBox.x / (MAP_SCALE * BLOCKSIZE)), 0, MAP_WIDTH-1  )
    local mapY = Lume.clamp(Lume.round(this.collBox.y / (MAP_SCALE * BLOCKSIZE)), 0, MAP_HEIGHT-1  )

    if MAP[mapX][mapY] ~= nil and this.animState ~='explode' then
        print('velY: '..this.velY)
        this.velY = 0
        this.velX = 0
        this:setAnimState('explode')
        MAP[mapX][mapY] = nil
        CAMERA.shake = true
        --ASSET.explosion['far']:setAttenuationDistances( Lume.distance(CAMERA.x, CAMERA.y, this.x, this.y), 1600 )
        --ASSET.explosion['far']:setDirection( (this.x - CAMERA.x ), ( this.y - CAMERA.y), 0 )
        if ASSET.explosion['far']:isPlaying() then ASSET.explosion['far']:stop() end
        ASSET.explosion['far']:play()
    end
    --Lovebird.print('NEARTILE.x: '..NEARTILE.x)
    --Lovebird.print('NEARTILE.y: '..NEARTILE.y)
    --if this.x > SCREEN_W or this.x < 0 or this.y > SCREEN_H then this.shouldDie = true end
    -- Lovebird.print(this.dirX)
    -- Lovebird.print(this.x)
    -- Lovebird.print(this.y)
end

local draw = function(this)
    love.graphics.draw(ASSET.mouettesAtlas, this.sprites[this.animState][this.keyframe],
            this.x,
            this.y,
            this.angle,
            this.drawScale ,
            this.drawScale * this.dirX,
            20*0.5,
            20*0.5)
    local r, g, b, a = love.graphics.getColor()
    if DEBUG then
        love.graphics.setColor(1,0,0,0.2)
        love.graphics.rectangle('fill', this.x - (20*this.drawScale*0.5), this.y - (20*this.drawScale*0.5), 20*this.drawScale, 20*this.drawScale)
        love.graphics.setColor(r, g, b, a)
    end
    --love.graphics.circle( 'fill', this.x, this.y, 3)
end

local animate = function(this, dt)
    this.animTimer = this.animTimer - dt
    if this.animTimer <= 0 then
        this.animTimer = 1 / this.fps
        this.keyframe = this.keyframe + 1
        if this.keyframe > this.nbrFrame then this.keyframe = 1 end
    end

    if this.animState == 'explode' and this.keyframe == this.nbrFrame then
        this.shouldDie = true
    end
end

local create = function()
    local mouette = {}
    mouette.init = init
    mouette.update =update
    mouette.draw = draw
    mouette.animate = animate
    mouette.setAnimState = setAnimState
    return mouette
end

return create