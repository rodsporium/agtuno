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

-- This is the core layout function. It arranges cards in a fan shape.
function CardArea:align_cards()
    local num_cards = #self.cards
    if num_cards == 0 then return end

    -- Loop through all cards in this area.
    for i, card in ipairs(self.cards) do
        -- Don't touch a card if the player is currently dragging it.
        if not card.states.drag.is then

            -- The math here creates the fan shape.
            -- It calculates a position and rotation for each card based on its
            -- index (i) in the hand.
            local fan_angle = 0.2 -- How much the fan spreads.
            local card_angle = (-num_cards/2 + i - 0.5) / num_cards
            
            card.T.r = card_angle * fan_angle
            
            -- Position the cards along the bottom of the screen.
            card.T.x = self.T.x + (self.T.w - self.card_w) * (i - 1) / math.max(num_cards - 1, 1) + (self.card_w - card.T.w) / 2
            
            -- The 'abs' function creates the curve of the fan.
            card.T.y = self.T.y + math.abs(card_angle) * 100
        end
    end
end

-- The update function for a CardArea simply tells it to re-align its cards.
-- This is useful for when a card is dropped back into the area.
function CardArea:update(dt)
    self:align_cards()
end
