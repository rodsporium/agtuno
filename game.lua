-- game.lua
-- This is the main game logic controller.

-- We 'extend' the base Object to create our Game class
Game = Object:extend()

-- -- The constructor for our Game class
function Game:init()
    -- Set the global G to point to this instance of the Game object
    G = self
    -- Call the function from globals.lua to populate the G table
    self:set_globals()
    self.E_MANAGER = EventManager()
end

-- This function is called once at the very beginning of the game
function Game:start_up()
    -- This function loads assets and prepares the game window
    self:set_render_settings()
    -- This function starts the game's title sequence
    self:splash_screen()
    -- -- Set the initial stage and state of the game using the global G table
    -- self.STAGE = G.STAGES.MAIN_MENU
    -- self.STATE = G.STATES.MENU

    -- -- A simple variable for our gameplay state
    -- self.player_score = 0
end

-- The main update loop, called every frame by main.lua
function Game:update(dt)
    -- Update the Event Manager first, as it controls animations and delays
    self.E_MANAGER:update(dt)
    -- Update all moveable objects
    for k, v in pairs(G.MOVEABLES) do
        v:move(dt)
    end
    -- -- Store delta time for use anywhere
    -- self.TIMERS.dt = dt

    -- -- ### STATE MACHINE ROUTER ###
    -- -- This is the core of the game's flow. We check the current state
    -- -- and call the appropriate update function.
    -- if self.STATE == G.STATES.MENU then
    --     self:update_menu(dt)
    -- elseif self.STATE == G.STATES.PLAYING then
    --     self:update_playing(dt)
    -- elseif self.STATE == G.STATES.GAME_OVER then
    --     self:update_game_over(dt)
    -- end
end

-- The main draw loop, called every frame by main.lua
function Game:draw()
    love.graphics.clear(G.C.BLACK)

    -- The main draw loop. It draws all parentless nodes.
    -- Children are drawn automatically by their parents.
    for k, v in pairs(G.I.NODE) do
        if not v.parent then
            love.graphics.push()
            v:translate_container()
            v:draw()
            love.graphics.pop()
        end
    end

    -- Draw the menu text if the flag is set
    if self.show_menu_text then
        love.graphics.setFont(love.graphics.newFont(36))
        love.graphics.printf("Press Enter to Start", 0, 450, 800, 'center')
    end
    -- -- ### STATE MACHINE RENDERER ###
    -- -- We check the current state and call the appropriate draw function.
    -- if self.STATE == G.STATES.MENU then
    --     self:draw_menu()
    -- elseif self.STATE == G.STATES.PLAYING then
    --     self:draw_playing()
    -- elseif self.STATE == G.STATES.GAME_OVER then
    --     self:draw_game_over()
    -- end
end

-- A simplified version of Balatro's asset loading function
function Game:set_render_settings()
    G.ASSET_ATLAS = {}
    -- NOTE: This requires the file 'resources/textures/1x/balatro.png' to exist
    if love.filesystem.getInfo("resources/textures/1x/balatro.png") then
        G.ASSET_ATLAS["balatro"] = {
            image = love.graphics.newImage("resources/textures/1x/balatro.png"),
            px = 333, py = 216
        }
    else
        -- Create a placeholder if the image is missing
        print("WARNING: 'resources/textures/1x/balatro.png' not found. Creating placeholder.")
        local canvas = love.graphics.newCanvas(333, 216)
        love.graphics.setCanvas(canvas)
        love.graphics.clear(G.C.RED)
        love.graphics.setCanvas()
        G.ASSET_ATLAS["balatro"] = { image = canvas, px = 333, py = 216 }
    end
end

-- Prepares the stage for a new scene
function Game:prep_stage(new_stage, new_state)
    G.STAGE = new_stage or G.STAGES.MAIN_MENU
    G.STATE = new_state or G.STATES.MENU
    
    -- G.ROOM is the main container for all game objects
    G.ROOM = Node{T={x = 0, y = 0, w = G.TILE_W, h = G.TILE_H}}
end

-- This is the function that starts the title screen animation
function Game:splash_screen()
    self:prep_stage(G.STAGES.MAIN_MENU, G.STATES.SPLASH)
    
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.TIMERS.TOTAL = 0
            G.TIMERS.REAL = 0
            
            -- Go to the main menu after a short delay
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                G:main_menu('splash')
                return true
            end}))
            return true
        end
    }))
end

-- This function sets up the main menu scene
function Game:main_menu(change_context)
    self:prep_stage(G.STAGES.MAIN_MENU, G.STATES.MENU)

    -- Create the background and logo sprites
    G.SPLASH_BACK = Sprite(-30, -13, G.ROOM.T.w+60, G.ROOM.T.h+22, G.ASSET_ATLAS["balatro"], {x=0,y=0})
    G.SPLASH_LOGO = Sprite(0, 0, 13, 13 * (216/333), G.ASSET_ATLAS["balatro"], {x=0, y=0})
    
    G.SPLASH_LOGO:set_alignment({ major = G.ROOM, type = 'cm', offset = {x=0, y=-2} })
    G.SPLASH_LOGO.dissolve = 1 -- Start invisible

    -- Use the event manager to fade in the logo
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.5,
        func = function()
            ease_value(G.SPLASH_LOGO, 'dissolve', -1, nil, nil, nil, 1.5)
            return true
        end
    }))

    -- Use the event manager to show the menu text after the logo
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 2.5,
        func = function()
            set_main_menu_UI()
            return true
        end
    }))
end

-- This function will eventually create the button UI. For now, it just sets a flag.
function Game:set_main_menu_UI()
    self.show_menu_text = true
end

-- A placeholder function needed by the engine files for animations
function ease_value(ref_table, ref_value, ease_to, _, _, _, duration)
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        ref_table = ref_table,
        ref_value = ref_value,
        ease_to = ref_table[ref_value] + ease_to,
        delay = duration or 1
    }))
end

-- -------------------------------------------------
-- -- STATE-SPECIFIC FUNCTIONS
-- -------------------------------------------------

-- -- Update logic for when we are in the main menu
-- function Game:update_menu(dt)
--     -- If the player presses 'enter', we change the state to start playing
--     if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('kpenter') then
--         self.STATE = G.STATES.PLAYING
--         self.player_score = 0 -- Reset score
--     end
-- end

-- -- Draw code for the main menu
-- function Game:draw_menu()
--     love.graphics.printf("MY AWESOME GAME", 0, 200, love.graphics.getWidth(), 'center')
--     love.graphics.printf("Press Enter to Start", 0, 300, love.graphics.getWidth(), 'center')
-- end

-- -- Update logic for when we are playing the game
-- function Game:update_playing(dt)
--     -- If the player presses 'space', increase the score
--     if love.keyboard.wasPressed('space') then
--         self.player_score = self.player_score + 10
--     end

--     -- If the player presses 'escape', go to game over
--     if love.keyboard.wasPressed('escape') then
--         self.STATE = G.STATES.GAME_OVER
--     end
-- end

-- -- Draw code for the gameplay
-- function Game:draw_playing()
--     love.graphics.printf("GAME IS RUNNING!", 0, 50, love.graphics.getWidth(), 'center')
--     love.graphics.printf("Score: " .. self.player_score, 0, 200, love.graphics.getWidth(), 'center')
--     love.graphics.printf("Press SPACE to score.", 0, 300, love.graphics.getWidth(), 'center')
--     love.graphics.printf("Press ESC for Game Over.", 0, 350, love.graphics.getWidth(), 'center')
-- end

-- -- Update logic for the game over screen
-- function Game:update_game_over(dt)
--     -- If the player presses 'enter', go back to the main menu
--     if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('kpenter') then
--         self.STATE = G.STATES.MENU
--     end
-- end

-- -- Draw code for the game over screen
-- function Game:draw_game_over()
--     love.graphics.printf("GAME OVER", 0, 200, love.graphics.getWidth(), 'center')
--     love.graphics.printf("Final Score: " .. self.player_score, 0, 250, love.graphics.getWidth(), 'center')
--     love.graphics.printf("Press Enter to return to Menu", 0, 350, love.graphics.getWidth(), 'center')
-- end
