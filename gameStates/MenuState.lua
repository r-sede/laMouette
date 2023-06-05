local MenuState = {}
-- Called once, and only once, before entering the state the first time. See Gamestate.switch().
function MenuState:init()
  self.menuItems = {}
  self.menuItems[0] = 'game'
  self.menuItems[1] = 'quit'
  --self.background = love.graphics.newImage('assets/bg.jpg')
end

--Called every time when entering the state. See Gamestate.switch().
function MenuState:enter(previous)
  self.cursor = 0
end

--Called when leaving a state. See Gamestate.switch() and Gamestate.pop().
function MenuState:leave()
end

--Called when re-entering a state by Gamestate.pop()-ing another state.
function MenuState:resume()
end

function MenuState:update(dt)
end

function MenuState:draw()
  love.graphics.print(self.menuItems[self.cursor%(#self.menuItems+1)], 0, 0)
  --love.graphics.print(self.cursor%(#self.menuItems+1), 0, 15)
end

--Called if the window gets or loses focus.
function MenuState:focus()
end

function MenuState:keypressed(key, code)
  if key == 'up' then
    self.cursor = self.cursor + 1
  elseif key == 'down' then
    self.cursor = self.cursor - 1
  elseif key == 'return' then
    if self.menuItems[self.cursor%(#self.menuItems+1)] == 'quit' then
      love.event.quit()
    elseif self.menuItems[self.cursor%(#self.menuItems+1)] == 'game' then
      GS.switch(GameState)
    end
  end
end

function MenuState:keyreleased()
end

function MenuState:mousepressed()
end

function MenuState:mousereleased()
end

function MenuState:joystickpressed()
end

function MenuState:joystickreleased()
end

function MenuState:quit()
end

return MenuState
