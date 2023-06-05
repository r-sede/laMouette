Camera    = require('libs/camera')

local create = function(x, y, mag, shakeTime)
    local camera = Camera(x or 0, y or 0)
    camera.mag = mag or 5
    camera.time = 0
    camera.shakeTime = shakeTime or 0.5
    camera.shake = false
    return camera
end

return create


