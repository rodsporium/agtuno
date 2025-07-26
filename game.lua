-- game.lua
-- This is the main game logic controller.

-- We 'extend' the base Object to create our Game class
Game = Object:extend()

-- The constructor for our Game class
function Game:init()
    -- Set the global G to point to this instance of the Game object
    G = self
    -- Call the function from globals.lua to populate the G table
    self:set_globals()
end

-- This function is called once at the very beginning of the game
function Game:start_up()
    -- Set the initial stage and state of the game using the global G table
    self.STAGE = G.STAGES.MAIN_MENU
    self.STATE = G.STATES.MENU

    -- A simple variable for our gameplay state
    self.player_score = 0
end

-- The main update loop, called every frame by main.lua
function Game:update(dt)
    -- Store delta time for use anywhere
    self.TIMERS.dt = dt

    -- ### STATE MACHINE ROUTER ###
    -- This is the core of the game's flow. We check the current state
    -- and call the appropriate update function.
    if self.STATE == G.STATES.MENU then
        self:update_menu(dt)
    elseif self.STATE == G.STATES.PLAYING then
        self:update_playing(dt)
    elseif self.STATE == G.STATES.GAME_OVER then
        self:update_game_over(dt)
    end
end

-- The main draw loop, called every frame by main.lua
function Game:draw()
    -- ### STATE MACHINE RENDERER ###
    -- We check the current state and call the appropriate draw function.
    if self.STATE == G.STATES.MENU then
        self:draw_menu()
    elseif self.STATE == G.STATES.PLAYING then
        self:draw_playing()
    elseif self.STATE == G.STATES.GAME_OVER then
        self:draw_game_over()
    end
end


-------------------------------------------------
-- STATE-SPECIFIC FUNCTIONS
-------------------------------------------------

-- Update logic for when we are in the main menu
function Game:update_menu(dt)
    -- If the player presses 'enter', we change the state to start playing
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('kpenter') then
        self.STATE = G.STATES.PLAYING
        self.player_score = 0 -- Reset score
    end
end

-- Draw code for the main menu
function Game:draw_menu()
    love.graphics.printf("MY AWESOME GAME", 0, 200, love.graphics.getWidth(), 'center')
    love.graphics.printf("Press Enter to Start", 0, 300, love.graphics.getWidth(), 'center')
end

-- Update logic for when we are playing the game
function Game:update_playing(dt)
    -- If the player presses 'space', increase the score
    if love.keyboard.wasPressed('space') then
        self.player_score = self.player_score + 10
    end

    -- If the player presses 'escape', go to game over
    if love.keyboard.wasPressed('escape') then
        self.STATE = G.STATES.GAME_OVER
    end
end

-- Draw code for the gameplay
function Game:draw_playing()
    love.graphics.printf("GAME IS RUNNING!", 0, 50, love.graphics.getWidth(), 'center')
    love.graphics.printf("Score: " .. self.player_score, 0, 200, love.graphics.getWidth(), 'center')
    love.graphics.printf("Press SPACE to score.", 0, 300, love.graphics.getWidth(), 'center')
    love.graphics.printf("Press ESC for Game Over.", 0, 350, love.graphics.getWidth(), 'center')
end

-- Update logic for the game over screen
function Game:update_game_over(dt)
    -- If the player presses 'enter', go back to the main menu
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('kpenter') then
        self.STATE = G.STATES.MENU
    end
end

-- Draw code for the game over screen
function Game:draw_game_over()
    love.graphics.printf("GAME OVER", 0, 200, love.graphics.getWidth(), 'center')
    love.graphics.printf("Final Score: " .. self.player_score, 0, 250, love.graphics.getWidth(), 'center')
    love.graphics.printf("Press Enter to return to Menu", 0, 350, love.graphics.getWidth(), 'center')
end
