---@class Moveable: Node
-- Moveable inherits from Node. This means it automatically gets all the properties
-- of a Node, like the self.T table for position and size.
Moveable = Node:extend()

-- This is the CONSTRUCTOR for Moveable. It runs when you create a new Moveable object.
function Moveable:init(args)
    -- First, we call the constructor of the parent class (Node).
    -- This sets up the self.T table (the TARGET transform).
    Node.init(self, args)

    -- This is the SECRET SAUCE of the entire animation system.
    -- We create a second transform table called 'VT' (Visible Transform).
    -- While 'T' is the GOAL or TARGET position, 'VT' is the position that is
    -- actually drawn on the screen each frame.
    -- We initialize it to be the same as 'T' so the object starts in the right place.
    self.VT = {
        x = self.T.x, y = self.T.y, w = self.T.w, h = self.T.h,
        r = self.T.r, scale = self.T.scale
    }

    -- This table will keep track of the object's speed.
    self.velocity = {x = 0, y = 0, r = 0, scale = 0}

    -- We add every new Moveable object to a global list.
    -- This allows our love.update function to easily find and update all of them.
    G.MOVEABLES = G.MOVEABLES or {}
    table.insert(G.MOVEABLES, self)
end

-- This is the CORE of the animation system!
-- It's called every single frame for every moveable object.
function Moveable:move(dt)
    -- Calculate the difference (the vector) between where the object SHOULD BE (T.x)
    -- and where it CURRENTLY IS on screen (VT.x).
    local dx = self.T.x - self.VT.x
    local dy = self.T.y - self.VT.y

    -- Move the VISIBLE position (VT) a small fraction of the way towards the TARGET position (T).
    -- The number '7' is the "easing factor". A higher number means faster, snappier movement.
    -- A lower number means slower, smoother movement.
    self.VT.x = self.VT.x + dx * 7 * dt
    self.VT.y = self.VT.y + dy * 7 * dt
    -- Over many frames, this creates the illusion of a smooth slide, or "tween".
end