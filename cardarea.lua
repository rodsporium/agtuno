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

-- emplace is now smarter. It can insert a card at a specific index.
function CardArea:emplace(card, index)
    if index then
        table.insert(self.cards, index, card)
    else
        table.insert(self.cards, card)
    end
    -- Tell the card which area it now belongs to.
    card.area = self
    -- Re-align all cards whenever a new one is added.
    self:align_cards()
end

-- This function now returns the index of the removed card.
function CardArea:remove_card(card)
    local removed_index = nil
    for i = #self.cards, 1, -1 do
        if self.cards[i] == card then
            removed_index = i
            table.remove(self.cards, i)
            break
        end
    end
    -- When a card is removed, we must clear its 'area' property
    -- so it knows it no longer belongs to this area.
    card.area = nil
    -- Re-align the remaining cards.
    self:align_cards()
    return removed_index
end

-- This function finds the card in this area closest to a given point (x, y).
-- It's the key to the card-swapping logic.
function CardArea:find_nearest_card(x, y)
    local nearest_card = nil
    local nearest_index = -1
    local min_dist = 999999 -- Start with a very large number.

    for i, card in ipairs(self.cards) do
        -- Use squared distance, which is faster than calculating a square root.
        local dist = (card.T.x - x)^2 + (card.T.y - y)^2
        if dist < min_dist then
            min_dist = dist
            nearest_card = card
            nearest_index = i
        end
    end
    return nearest_card, nearest_index
end

-- NEW: This function performs a direct swap of two cards within the same area.
function CardArea:swap_cards(card1_idx, card2_idx)
    if card1_idx and card2_idx and self.cards[card1_idx] and self.cards[card2_idx] then
        -- This is a standard Lua trick to swap two table elements without a temporary variable.
        self.cards[card1_idx], self.cards[card2_idx] = self.cards[card2_idx], self.cards[card1_idx]
        self:align_cards()
    end
end

-- This is the core logic for arranging the cards in a visually appealing fan.
function CardArea:align_cards()
    local num_cards = #self.cards
    if num_cards == 0 then return end

    -- Define the angles for our "half octagon" shape.
    local angle_far = 0.35   -- The angle for the outermost cards.
    local angle_near = 0.15  -- The angle for the inner cards.

    local curve_height = self.T.h * 0.4 -- A shallower curve
    local overlap_factor = 0.25 -- Increased overlap for a tighter hand

    -- Calculate the total width of the fanned cards to center them.
    local total_fan_width = (num_cards - 1) * (self.card_w * overlap_factor)

    for i, card in ipairs(self.cards) do
        -- NEW: The CardArea is now responsible for telling each card its index.
        -- This is what the new sorting logic in game.lua uses.
        card.hand_idx = i

        -- This logic only applies to cards that are not currently being dragged.
        if not card.states.drag.is then
            -- Calculate a "normalized position" for the card in the hand.
            -- This gives a value from -0.5 (leftmost card) to 0.5 (rightmost card).
            local norm_pos = 0
            if num_cards > 1 then
                -- -0.5 (left) to 0.5 (right)
                norm_pos = ((i - 1) / (num_cards - 1)) - 0.5 
            end

            -- UPDATED: Instead of a smooth rotation, we use steps to create an angular fan.
            -- This checks which "segment" the card is in and applies a fixed angle.
            if norm_pos < -0.35 then -- Far-left segment
                card.T.r = -angle_far
            elseif norm_pos < -0.15 then -- Inner-left segment
                card.T.r = -angle_near
            elseif norm_pos <= 0.15 then -- Center segment
                card.T.r = 0
            elseif norm_pos <= 0.35 then -- Inner-right segment
                card.T.r = angle_near
            else -- Far-right segment
                card.T.r = angle_far
            end

            -- Set the TARGET horizontal position, creating the fanned-out spread.
            card.T.x = self.T.x + (self.T.w / 2) - (total_fan_width / 2) - (self.card_w/2) + (i-1) * (self.card_w * overlap_factor)
            -- Adjust the y-position using a sine wave for a smoother arc
            card.T.y = self.T.y + (self.T.h * 0.3) - (card.T.h / 2) + (math.abs(norm_pos)^2) * curve_height
        end
    end
end

-- The update function for a CardArea simply tells it to re-align its cards every frame.
-- This ensures that when a card is dropped back into the area, the hand rearranges itself.
function CardArea:update(dt)
    self:align_cards()
end
