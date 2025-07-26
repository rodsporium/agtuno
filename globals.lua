-- globals.lua
-- This file defines the global 'G' table which will hold all our game-wide data.

function Game:set_globals()
    
    -- Game Version
    self.VERSION = '0.1.0'

    --||||||||||||||||||||||||||||||
    --             Time
    --||||||||||||||||||||||||||||||
    -- A table for holding timers, like delta time (dt)
    self.TIMERS = {
        TOTAL = 0,
        REAL = 0,
        REAL_SHADER = 0,
        UPTIME = 0,
        BACKGROUND = 0
    }

    --||||||||||||||||||||||||||||||
    --          INSTANCES
    --||||||||||||||||||||||||||||||
    self.ARGS = {}
    -- Instance tables for all object types
    self.I = {
        NODE = {},
        MOVEABLE = {},
        SPRITE = {},
        UIBOX = {},
        POPUP = {},
        CARD = {},
        CARDAREA = {},
        ALERT = {}
    }

    -- Other essential global tables
    self.MOVEABLES = {}
    self.ANIMATIONS = {}
    self.DRAW_HASH = {}
    self.STAGE_OBJECTS = { {}, {}, {} } -- One table for each stage
    self.SETTINGS = { -- Simplified settings
        paused = false,
        GAMESPEED = 1,
        reduced_motion = false,
        GRAPHICS = { texture_scaling = 1 }
    }
    
    --||||||||||||||||||||||||||||||
    --        GAMESTATES
    --||||||||||||||||||||||||||||||
    -- Game States
    self.STAGES = { MAIN_MENU = 1, RUN = 2, SANDBOX = 3 }
    self.STATES = {
        SELECTING_HAND = 1,
        HAND_PLAYED = 2,
        DRAW_TO_HAND = 3,
        GAME_OVER = 4,
        SHOP = 5,
        PLAY_TAROT = 6,
        BLIND_SELECT = 7,
        ROUND_EVAL = 8,
        TAROT_PACK = 9,
        PLANET_PACK = 10,
        MENU = 11,
        TUTORIAL = 12,
        SPLASH = 13
    }
    self.STAGE = 1
    self.STATE = 13

    --||||||||||||||||||||||||||||||
    --        RENDER SCALE
    --||||||||||||||||||||||||||||||
    -- Render Scale & Constants
    self.TILESIZE = 20
    self.TILESCALE = 3.65
    self.TILE_W = 20
    self.TILE_H = 11.5
    self.CARD_W = 2.4 * 35 / 41
    self.CARD_H = 2.4 * 47 / 41

    --||||||||||||||||||||||||||||||
    --        COLOURS
    --||||||||||||||||||||||||||||||
    -- Colours
    self.C = {
            MULT = {1,0.3,0.3,1},
            CHIPS = {0,0.6,1,1},
            MONEY = {1,0.8,0.2,1},
            XMULT = {1,0.3,0.3,1},
            FILTER = {1,0.6,0,1},
            BLUE = {0,0.6,1,1},
            RED = {1,0.3,0.3,1},
            GREEN = {0.2,0.8,0.2,1},
            ORANGE = {1,0.5,0,1},
            GOLD = {1,0.8,0.2,1},
            WHITE = {1,1,1,1},
            PURPLE = {0.6,0.3,0.8,1},
            BLACK = {0.1,0.1,0.1,1},
            L_BLACK = {0.2,0.2,0.2,1},
            GREY = {0.5,0.5,0.5,1},
            CLEAR = {0,0,0,0},
            UI = { 
                TEXT_LIGHT = {1,1,1,1},
                TEXT_DARK = {0.2,0.2,0.2,1}
            }
        }

end

G = Game()
