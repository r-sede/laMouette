-- rafiki util cli:
print('welcome to the rafiki console cli, try exec command: ')

local usageString             = 'usage: bla bla bla'
local gameStatesFolder        = 'gameStates'
local includeStateFileName    = 'states.lua'
local currentOsPathSeparator  = package.path:match( "(%p)%?%." )

local validCommand =
{
  'create',
}

local stateTemplate =
[[
local {{stateName}} = {}

-- Called once, and only once, before entering the state the first time. See Gamestate.switch().
function {{stateName}}:init()
end

--Called every time when entering the state. See Gamestate.switch().
function {{stateName}}:enter(previous)
end

--Called when leaving a state. See Gamestate.switch() and Gamestate.pop().
function {{stateName}}:leave()
end

--Called when re-entering a state by Gamestate.pop()-ing another state.
function {{stateName}}:resume()
end

function {{stateName}}:update(dt)
end

function {{stateName}}:draw()
end

--Called if the window gets or loses focus.
function {{stateName}}:focus()
end

function {{stateName}}:keypressed()
end

function {{stateName}}:keyreleased()
end

function {{stateName}}:mousepressed()
end

function {{stateName}}:mousereleased()
end

function {{stateName}}:joystickpressed()
end

function {{stateName}}:joystickreleased()
end

function {{stateName}}:quit()
end

return {{stateName}}
]]

local function printUsage()
  print(usageString)
end

function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

function contains (arr, val)
  for index, value in ipairs(arr) do
      if value == val then
          return true
      end
  end

  return false
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if arg[1] == nil or arg[2] == nil then
  printUsage()
  return
end

local command = (arg[1]):split(':')

if (contains(validCommand, command[1]) == false ) then
  printUsage()
  return
end

--create commands
if (command[1] == 'create') then
  local validCreate =
  {
    'state'
  }

  if (contains(validCreate, command[2]) == false ) then
    printUsage()
    return
  end

  local createCommand = command[2]

  if (createCommand == 'state') then
    local filePath = gameStatesFolder..currentOsPathSeparator..arg[2]
--    print(filePath)
    if (file_exists(filePath)) then
      print('file: '..filePath..' already exist.')
      return
    end
    local stateName = (arg[2]):split(currentOsPathSeparator)
    stateName = stateName[#stateName]
    stateName = (stateName:split('.'))[1]
    local res = string.gsub(stateTemplate, '{{stateName}}', stateName)
    local stateFile = io.open(filePath, 'w')
    stateFile:write(res)
    stateFile:close()

    --add require line for the new state
    local includeStateFilePath  = (gameStatesFolder..currentOsPathSeparator..includeStateFileName)
    if not(file_exists(includeStateFilePath)) then
      print('file: '..includeStateFilePath..' not found.')
      return
    end
    local includeStateFile = io.open(includeStateFilePath, 'a')
    local includeStringTemplate =
[[
{{stateName}} = require('gameStates/{{stateName}}')
]]
    local includeResLine = string.gsub(includeStringTemplate, '{{stateName}}', stateName)
    includeStateFile:write(includeResLine)
    includeStateFile:close()
    print('new state created at: '..filePath)
    return
  end

end


