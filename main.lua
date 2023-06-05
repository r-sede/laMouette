--Global
require('includes')
require('gameStates/states')
UTIL = require('model/Util')
ASSET = {}

function love.load(args)
  ASSET.turret = love.graphics.newImage('assets/turret1-big.png')
  ASSET.canon =  love.graphics.newImage('assets/canon.png')
  ASSET.mouettesAtlas = love.graphics.newImage('assets/bird_20x20px.png')
  ASSET.tilesAtlas = love.graphics.newImage('assets/TileSet_PAck_DB16_Sheet.png')
  ASSET.mouettesSound = {
    love.audio.newSource('assets/mouette1.wav', 'static'),
    love.audio.newSource('assets/mouette2.wav', 'static')
  }
  ASSET.explosion = {
    far = love.audio.newSource('assets/explosionFarM.wav', 'static'),
  }
  love.graphics.setDefaultFilter('nearest')
  GS.registerEvents()
  GS.switch(MenuState)

end

function love.update(dt)
  Lovebird.update()
end

function love.draw()
end

function love.keypressed(key, code)
end