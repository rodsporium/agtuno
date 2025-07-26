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
    -- Set the initial stage and state of the game
    self.STAGE = self.STAGES.MAIN_MENU
    self.STATE = self.STATES.MENU

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
    if self.STATE == self.STATES.MENU then
        self:update_menu(dt)
    elseif self.STATE == self.STATES.PLAYING then
        self:update_playing(dt)
    elseif self.STATE == self.STATES.GAME_OVER then
        self:update_game_over(dt)
    end
end

-- The main draw loop, called every frame by main.lua
function Game:draw()
    -- ### STATE MACHINE RENDERER ###
    -- We check the current state and call the appropriate draw function.
    if self.STATE == self.STATES.MENU then
        self:draw_menu()
    elseif self.STATE == self.STATES.PLAYING then
        self:draw_playing()
    elseif self.STATE == self.STATES.GAME_OVER then
        self:draw_game_over()
    end
end
