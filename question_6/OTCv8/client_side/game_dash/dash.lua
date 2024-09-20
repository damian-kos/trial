--[[  
  In dash.otmod file we need to load dependency of   
    dependencies:
      - game_shaders
  So we can use a shaders defined there 
]]--

-- Define constants for shader codes and the dash command.
local DASH_SHADER_CODE = '50'
local DEFAULT_SHADER_CODE = '51'
local DO_DASH = 'doDash'
local OPCODE_DASH = 15
local OUTLINE_SHADER = 'Outfit - Outline'
local DEFAULT_SHADER = 'Default'


-- Initializes the module, registering the dash opcode and setting up UI and keybinds.
function init()
  -- Register the dash opcode with the game protocol.
  ProtocolGame.registerExtendedOpcode(OPCODE_DASH, dashCode)

  -- Bind the 'Ctrl+Y' keyboard shortcut to trigger the dash action.
  g_keyboard.bindKeyDown('Ctrl+Y', doDash)
  -- Add a button to the game's UI for the dash action.
  modules.client_topmenu.addLeftGameButton('dashButton', tr('Dash'), '/modules/game_dash/images/dashIcon', doDash)
end

-- Cleans up the module by unregistering the dash opcode on termination.
function terminate()
  ProtocolGame.unregisterExtendedOpcode(OPCODE_DASH, dashCode)
end

-- Triggers the dash action by sending the appropriate opcode and command to the server.
function doDash()
  sendMyCode(DO_DASH)
end

-- Sends a custom opcode and buffer to the game server.
function sendMyCode(codeBuffer)
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    protocolGame:sendExtendedOpcode(OPCODE_DASH, codeBuffer)
  end
end

-- Handles server responses related to the dash feature, adjusting player shaders accordingly.
function dashCode(protocol, code, buffer)
  local player = g_game.getLocalPlayer()
   -- Set the player's shader to an outlined effect if the dash shader code is received.
  if buffer == DASH_SHADER_CODE then
    player:setShader(OUTLINE_SHADER)
    return true
  end
 -- Revert the player's shader to the default if the default shader code is received.
  if buffer == DEFAULT_SHADER_CODE then
    player:setShader(DEFAULT_SHADER)
    return true
  end
  return false
end