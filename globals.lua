-- globals.lua
-- This file defines the global 'G' table which will hold all our game-wide data.

function Game:set_globals()
    
    -- Game Version
    self.VERSION = '0.1.0',

    -- A table for holding timers, like delta time (dt)
    self.TIMERS = {},

    -- A simple state machine using enums (tables)
    self.STAGES = {
        MAIN_MENU = 1,
        GAMEPLAY = 2,
    },
    self.STATES = {
        MENU = 1,
        PLAYING = 2,
        GAME_OVER = 3,
    },

    -- A table for colors (Red, Green, Blue, Alpha), values from 0 to 1
    self.C = {
        BLACK = {0, 0, 0, 1},
        WHITE = {1, 1, 1, 1},
        RED = {1, 0, 0, 1},
        GREY = {0.5, 0.5, 0.5, 1}
    },

    -- We will set the current stage and state in the Game object itself
    self.STAGE = 0,
    self.STATE = 0,

    x = 100

end

G = Game()
