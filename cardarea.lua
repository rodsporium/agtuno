-- cardarea.lua
-- This class defines a region on the screen that can hold and arrange cards.

---@class CardArea: Moveable
CardArea = Moveable:extend()

function CardArea:init(X, Y, W, H, config)
    Moveable.init(self, { T = {x=X, y=Y, w=W, h=H} })

    self.config = config or {}
    self.cards = {}
    self.card_w = 71 * 1.5 -- Standard card width
end

-- Adds a card to this area's internal list and tells the card about its new home.
function CardArea:emplace(card)
    table.insert(self.cards, card)
    card.area = self
    self:align_cards() -- Re-align all cards whenever a new one is added.
end

-- Removes a card from this area's list.
function CardArea:remove_card(card)
    for i = #self.cards, 1, -1 do
        if self.cards[i] == card then
            table.remove(self.cards, i)
            break
        end
    end
    card.area = nil
    self:align_cards() -- Re-align all cards whenever one is removed.
end

-- UPDATED: The alignment logic now arranges cards in a curved fan shape.
function CardArea:align_cards()
    local num_cards = #self.cards
    if num_cards == 0 then return end

    -- Define the properties of the fan
    local max_rotation = 0.4 -- The total rotation from one end of the fan to the other.
    local fan_width = self.T.w * 0.7 -- How much horizontal space the fan occupies.
    local curve_height = self.T.h * 0.4 -- How high the arc of the fan is.
    local overlap_factor = 0.6 -- How much the cards overlap. A smaller number means more overlap.

    -- Calculate the total width of the fanned cards to center them.
    local total_fan_width = (num_cards - 1) * (self.card_w * overlap_factor)

    for i, card in ipairs(self.cards) do
        if not card.states.drag.is then

            -- Calculate a normalized position for the card in the hand (-0.5 for the leftmost card, 0.5 for the rightmost).
            local norm_pos = 0
            if num_cards > 1 then
                norm_pos = ((i - 1) / (num_cards - 1)) - 0.5
            end

            -- 1. Set the rotation based on the normalized position.
            card.T.r = norm_pos * max_rotation

            -- 2. Set the horizontal position, creating the fan spread.
            card.T.x = self.T.x + (self.T.w / 2) - (total_fan_width / 2) - (self.card_w/2) + (i-1) * (self.card_w * overlap_factor)

            -- 3. Set the vertical position using a parabola (x^2) to create the curve.
            card.T.y = self.T.y + (self.T.h / 2) - (card.T.h / 2) + (norm_pos^2) * curve_height
        end
    end
end

-- The update function for a CardArea simply tells it to re-align its cards.
-- This is useful for when a card is dropped back into the area.
function CardArea:update(dt)
    self:align_cards()
end
