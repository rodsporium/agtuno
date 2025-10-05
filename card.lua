-- card.lua
-- This is the blueprint for all cards in the game.

---@class Card: Moveable
-- Card now inherits from Moveable. This makes it a logical container
-- for its visual parts (the sprites).
Card = Moveable:extend()

-- This is the CONSTRUCTOR for a Card object.
function Card:init(X, Y, W, H, card_front, center, params)
    -- The 'center' table is the prototype data from G.P_CENTERS.
    self.config = {
        center = center
    }

    -- The 'card' table is the prototype data for the card's face (rank and suit).
    self.config.card = card_front

    -- Call the parent Moveable constructor. The Card itself is an invisible container.
    Moveable.init(self, { T = {x = X, y = Y, w = W, h = H} })
    self.states.collide.can = true -- Make the card collider active.

    -- Create the CARD FRONT sprite as a child of this Card object.
    self.children.front = Sprite({
        T = {x = X, y = Y, w = W, h = H},
        atlas = G.ASSET_ATLAS.cards,
        sprite_pos = self.config.card.pos
    })
    self.children.front:set_role({major = self, role_type = 'Glued'})

    -- Create the CARD CENTER sprite as a child.
    self.children.center = Sprite({
        T = {x = X, y = Y, w = W, h = H},
        atlas = G.ASSET_ATLAS.centers,
        sprite_pos = self.config.center.pos
    })
    self.children.center:set_role({major = self, role_type = 'Glued'})

    -- Create the CARD BACK sprite as a child.
    self.children.back = Sprite({
        T = {x = X, y = Y, w = W, h = H},
        atlas = G.ASSET_ATLAS.card_back,
        sprite_pos = {x=0, y=0}
    })
    self.children.back:set_role({major = self, role_type = 'Glued'})

    -- Add a 'facing' state to track which side is up.
    self.facing = 'front'

    -- Add this card to the global list of cards.
    if getmetatable(self) == Card then
        table.insert(G.I.CARD, self)
    end
end

-- NEW: This function is called by the controller when the mouse is over the card.
function Card:hover()
    -- We set the TARGET scale to 110%. The move() function will handle the smooth animation.
    self.T.scale = 1.1
end

-- NEW: This function is called by the controller when the mouse leaves the card.
function Card:stop_hover()
    -- We set the TARGET scale back to 100%.
    self.T.scale = 1.0
end

-- This function handles the flipping animation.
function Card:flip()
    -- Animate the card shrinking on the X-axis.
    ease_value(self.VT, 'w', 0, 'linear', 0.2)

    -- Schedule an event to happen after the shrink animation is complete.
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            -- Toggle the facing direction.
            if self.facing == 'front' then
                self.facing = 'back'
            else
                self.facing = 'front'
            end
            -- Animate the card growing back to its original width.
            ease_value(self.VT, 'w', self.T.w, 'linear', 0.2)
            return true -- Remove this event from the queue.
        end
    }))
end

-- The Card's draw function now explicitly draws its children based on its state.
function Card:draw()
    -- A Card itself doesn't have a visual; it just manages its children.
    -- We check the 'facing' state to decide which children to draw.
    if self.facing == 'back' then
        self.children.back:draw()
    else
        -- Draw the center (background) first, then the front (rank/suit) on top.
        self.children.center:draw()
        self.children.front:draw()
    end
end

