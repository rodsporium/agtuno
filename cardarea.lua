-- This class defines a region on the screen that can hold and arrange cards.
---@class CardArea: Moveable
CardArea = Moveable:extend()

function CardArea:init(X, Y, W, H, config)
    Moveable.init(self, { T = {x=X, y=Y, w=W, h=H} })

    self.config = config or {}
    self.cards = {}
    self.card_w = 71 * 1.5 -- Standard card width
    -- The area now knows its maximum capacity.
    self.card_limit = config.card_limit or 13
end

-- This function adds a card to the area.
function CardArea:emplace(card)
    table.insert(self.cards, card)
    -- Tell the card which area it now belongs to.
    card.area = self
    -- Re-align all cards whenever a new one is added.
    self:align_cards()
end

-- This function removes a specific card from the area.
function CardArea:remove_card(card)
    for i = #self.cards, 1, -1 do
        if self.cards[i] == card then
            table.remove(self.cards, i)
            break
        end
    end
    -- When a card is removed, we must clear its 'area' property
    -- so it knows it no longer belongs to this area.
    card.area = nil
    -- Re-align the remaining cards.
    self:align_cards()
end

-- This function finds the card in this area closest to a given point (x, y).
-- It's the key to the card-swapping logic.
function CardArea:find_nearest_card(x, y)
    local nearest_card = nil
    local min_dist = 999999 -- Start with a very large number.

    for _, card in ipairs(self.cards) do
        -- Use squared distance, which is faster than calculating a square root.
        local dist = (card.T.x - x)^2 + (card.T.y - y)^2
        if dist < min_dist then
            min_dist = dist
            nearest_card = card
        end
    end
    return nearest_card
end

-- This is the core logic for arranging the cards in a visually appealing fan.
function CardArea:align_cards()
    local num_cards = #self.cards
    if num_cards == 0 then return end

    -- Define the properties of the fan shape.
    local max_rotation = 0.4 -- The total rotation from one end of the fan to the other.
    local curve_height = self.T.h * 0.4 -- How high the arc of the fan is.
    local overlap_factor = 0.6 -- How much the cards overlap. A smaller number means more overlap.

    -- Calculate the total width of the fanned cards to center them.
    local total_fan_width = (num_cards - 1) * (self.card_w * overlap_factor)

    for i, card in ipairs(self.cards) do
        -- This logic only applies to cards that are not currently being dragged.
        if not card.states.drag.is then
            -- Calculate a "normalized position" for the card in the hand.
            -- This gives a value from -0.5 (leftmost card) to 0.5 (rightmost card).
            local norm_pos = 0
            if num_cards > 1 then
                norm_pos = ((i - 1) / (num_cards - 1)) - 0.5
            end
            -- 1. Set the TARGET rotation based on the normalized position.
            card.T.r = norm_pos * max_rotation
            -- 2. Set the TARGET horizontal position, creating the fanned-out spread.
            card.T.x = self.T.x + (self.T.w / 2) - (total_fan_width / 2) - (self.card_w/2) + (i-1) * (self.card_w * overlap_factor)
            -- 3. Set the TARGET vertical position using a parabola (norm_pos^2) to create the curve.
            card.T.y = self.T.y + (self.T.h / 2) - (card.T.h / 2) + (norm_pos^2) * curve_height
        end
    end
end

-- The update function for a CardArea simply tells it to re-align its cards every frame.
-- This ensures that when a card is dropped back into the area, the hand rearranges itself.
function CardArea:update(dt)
    self:align_cards()
end
