

local init = function(this, width, height, smoothFact, seed)
  this.width = width
  this.height = height
  this.smoothFact = smoothFact
  this.seed = seed or 1
  love.math.setRandomSeed( os.time())
  print(os.time())
end

local generate = function(this ,empty, invert)
  local map = {}
  local fillWith = 1

  if empty then fillWith = 0 end 

  for col=1,this.width do
    map[col] = {}
    for row=1,this.height do
      map[col][row] = fillWith
    end
  end

  local perlinHeight

  for x=1,this.width do
    perlinHeight = math.floor((love.math.noise( (x) / this.smoothFact) * this.height / 2)+0.5 )
    perlinHeight = perlinHeight + this.height  / 2
    print(perlinHeight)
    for y=perlinHeight,1, -1 do
      map[x][y] = 1
    end
  end

  if invert then
    for col=1,#map do
      for row=1,#map[col] do
        if map[col][row] == 1 then
          map[col][row] = 0
        else
          map[col][row] = 1
        end 
      end
    end
  end

  return map

end

local create = function()
  local mapGenerator = {}
  mapGenerator.init = init
  mapGenerator.generate = generate
  return mapGenerator
end

return create