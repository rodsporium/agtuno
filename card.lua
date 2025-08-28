-- card.lua
-- This is the blueprint for all cards in the game.

---@class Card: Sprite
Card = Sprite:extend()

-- This is the CONSTRUCTOR for a Card object.
-- It takes a position/size (T) and the KEY of the card to look up (center).
function Card:init(X, Y, W, H, card_front, center, params)
    -- The 'center' table is the prototype data from G.P_CENTERS.
    self.config = {
        center = center
    }

    -- The 'card' table is the prototype data for the card's face (rank and suit).
    -- For this test, we will get this from P_CARDS.
    self.config.card = card_front

    -- We now have all the data we need. We can call the Sprite constructor
    -- to create the actual visible object.
    -- FIXED: We now pass a single table containing the transform (T),
    -- the atlas, and the sprite_pos, as the parent constructors expect.
    Sprite.init(self, {
        T = {x = X, y = Y, w = W, h = H},
        atlas = G.ASSET_ATLAS.cards,
        sprite_pos = self.config.card.pos
    })

    -- A card also has a "center" sprite (for Jokers, etc.)
    -- For a playing card, this is just the base card back design.
    -- FIXED: The Sprite constructor also needs a single table.
    self.children.center = Sprite({
        T = {x = X, y = Y, w = W, h = H},
        atlas = G.ASSET_ATLAS.centers,
        sprite_pos = self.config.center.pos
    })
    self.children.center:set_role({major = self, role_type = 'Glued'})

    -- Add the card to the global instance list for cards.
    if getmetatable(self) == Card then
        table.insert(G.I.CARD, self)
    end
end

-- The Card's draw function is more complex. It needs to draw the center/back,
-- then the front (rank/suit), and any other effects like editions.
function Card:draw()
    -- For this simple test, we will just draw the main sprite and its center.
    Sprite.draw(self)
    self.children.center:draw()
end