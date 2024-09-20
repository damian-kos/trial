-- Set a margin for positioning calculations.
local MARGIN = 10
-- Declare variables to hold the window and button objects.
local window
local jumpBtn

function init()
    -- Establish connections, if any, with the game.
    connect(g_game, { })
    -- Load the UI layout for the window from the OTUI file.
    window = g_ui.loadUI('client_jump_button', rootWidget)
    -- Retrieve the button widget by its ID within the loaded UI.
    jumpBtn = window:getChildById('jumpBtn')
    -- Start the animation of the button floating within the window.
    startFloatingButton()
end

function terminate()
    -- Clean up connections when the module is terminated.
    disconnect(g_game, { })
end

function setButtonPosition(x, y)
    -- Directly updates the button's position to the specified coordinates.
    -- This provides a central function to change the button's position, 
    -- making future adjustments or additions simpler.
    jumpBtn:setPosition({x = x, y = y})
end

function getRandomYPosition()
    -- Calculates a random Y position for the button that ensures it stays
    -- within the vertical bounds of the window, taking into account the button's height.
    local winPos = window:getPosition()
    local winSize = window:getSize() 
    local jumpBtnSize = jumpBtn:getSize()
    return math.random(winPos.y + jumpBtnSize.height, winPos.y + winSize.height - jumpBtnSize.height)
end

function moveButtonToLeftEdge()
    -- Moves the button to the right edge of the window with a new, random Y position.
    -- This function is called when the button reaches the left margin boundary,
    -- creating a loop effect where the button reappears from the right.
    local winSize = window:getSize()
    local winPos = window:getPosition()
    local jumpBtnSize = jumpBtn:getSize()
    setButtonPosition(winSize.width + winPos.x - jumpBtnSize.width  - MARGIN, getRandomYPosition())
end

function startFloatingButton()
    -- Continuously updates the button's position, moving it leftward until it reaches
    -- the left edge, at which point it resets to the right edge with a random Y position.
    local function updateButtonPosition()
        local winPos = window:getPosition()
        local jumpBtnPos = jumpBtn:getPosition()

        -- Move the button left by decrementing its X position.
        jumpBtnPos.x = jumpBtnPos.x - 1

        -- Check if the button has moved beyond the left margin.
        -- If so, move it to the right edge with a new Y position.
        -- Otherwise, update its position to continue moving left.
        if jumpBtnPos.x < (winPos.x + MARGIN) then
            moveButtonToLeftEdge()
        else
            setButtonPosition(jumpBtnPos.x, jumpBtnPos.y)
        end

        -- Schedule the next update, creating a loop of movement.
        scheduleEvent(updateButtonPosition, 5) -- The delay controls the speed of movement. Found in globals.lua
    end

    updateButtonPosition() -- Initiates the floating movement.
end
