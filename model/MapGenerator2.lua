function lerp(a,b,t)
  return a * (1-t) + t * b
end

local generateWhiteNoise = function(width)
  local array = {}
-- array[0] = 0.033082366
-- array[1] = 0.40766782
-- array[2] = 0.24526197
-- array[3] = 0.58298206
-- array[4] = 0.867829
-- array[5] = 0.417131
-- array[6] = 0.41260642
-- array[7] = 0.5351053
-- array[8] = 0.26151025
-- array[9] = 0.72361636
  


  for i=0,width-1 do
    array[i]= love.math.random()
  end

  return array
end

local generateSmoothNoise = function(baseNoise, width, octave)
  -- local width = #baseNoise
  -- print('_________________________________________')
  -- print('__________________OCTAVE_________________')
  -- print('_________________________________________')
  -- print('octave: '..octave)
  local smoothNoise = {}
  local samplePeriod = 2^octave
  local sampleFrequency = 1 / samplePeriod
  -- print('samplePeriod: '..samplePeriod)
  -- print('sampleFrequency: '..sampleFrequency)
  -- print('width: '..width)
  for i=0,width-1 do
    local sample_i0 = math.floor(i / samplePeriod) * samplePeriod
    local sample_i1 = ( sample_i0 + samplePeriod ) % width
    local blend = (i - sample_i0) * sampleFrequency
    local top = lerp(baseNoise[sample_i0], baseNoise[sample_i1], blend)
    smoothNoise[i] = top
    -- print('sample_i0: '..sample_i0)
    -- print('sample_i1: '..sample_i1)
    -- print('blend: '..blend)
    -- print('baseNoise[sample_i0]: '..baseNoise[sample_i0])
    -- print('baseNoise[sample_i1]: '..baseNoise[sample_i1])
    -- print('top: '..top)
  end

  return smoothNoise
end

local generatePerlinNoise = function(baseNoise, width, octaveCount)
  -- local width = #baseNoise
  local smoothNoise = {}
  local persistance = 0.5

  for i=0,octaveCount-1 do
    smoothNoise[i] = generateSmoothNoise(baseNoise, width, i)
  end

  local perlinNoise = {}

  for i=0,width-1 do
    perlinNoise[i] = 0
  end

  local amplitude = 1
  local totalAmplitude = 0

  for octave = octaveCount - 1, 0, -1 do
    amplitude = amplitude * persistance
    totalAmplitude = totalAmplitude + amplitude

    for i=0, width-1 do
      perlinNoise[i] = perlinNoise[i] + smoothNoise[octave][i] * amplitude
    end
  end

  for i=0, width-1 do
      perlinNoise[i] = perlinNoise[i] / totalAmplitude 
  end

  return perlinNoise

end



local generate = function(this, width , octave, amplitude, _seed)
  local seed = _seed or os.time()
  love.math.setRandomSeed(seed)
  print(seed)

  -- print('lerp -> '..lerp(0.033082366,0.26151025,0.0703125))
  local wthNoise = generateWhiteNoise(width)
  local perlinNoiseArr = generatePerlinNoise(wthNoise, width, octave)
  

  local map = {}

  for i=0, width-1 do
    map[i] = perlinNoiseArr[i] * amplitude  + (MAP_HEIGHT / 2)
  end



  local yes = {}

  for xx=0,width-1 do
    yes[xx] = {}
    for yy = MAP_HEIGHT , MAP_HEIGHT - math.floor(map[xx]), -1 do
      if yy == MAP_HEIGHT - math.floor(map[xx]) then
        yes[xx][yy] = 2
        yes[xx].height = yy
        --print(yes[xx].height)
      else
        yes[xx][yy] = 1
      end
    end
  end
  
  return yes
end

local create = function()
  local mapGenerator = {}
  mapGenerator.generate = generate
  return mapGenerator
end

return create