---@class Moveable: Node
-- Moveable inherits from Node. This means it automatically gets all the properties
-- of a Node, like the self.T table for position and size.
Moveable = Node:extend()

-- This is the CONSTRUCTOR for Moveable. It runs when you create a new Moveable object.
function Moveable:init(args)
    -- First, we call the constructor of the parent class (Node).
    -- This sets up the self.T table (the TARGET transform).
    Node.init(self, args)

    -- Store the base width and height for scaling calculations.
    self.base_w = self.T.w
    self.base_h = self.T.h

    -- We create a second transform table called 'VT' (Visible Transform).
    -- While 'T' is the GOAL or TARGET position, 'VT' is the position that is
    -- actually drawn on the screen each frame.
    -- We initialize it to be the same as 'T' so the object starts in the right place.
    self.VT = {
        x = self.T.x,
        y = self.T.y,
        w = self.T.w,
        h = self.T.h,
        r = self.T.r,
        scale = self.T.scale
    }

    -- This table will keep track of the object's speed.
    self.velocity = {
        x = 0,
        y = 0,
        r = 0,
        scale = 0
    }

    -- This 'role' table will define how this object is attached to another.
    self.role = {
        role_type = 'Major',
        major = self,
        offset = {x=0, y=0}
    }

    -- We add every new Moveable object to a global list.
    -- This allows our love.update function to easily find and update all of them.
    G.MOVEABLES = G.MOVEABLES or {}
    table.insert(G.MOVEABLES, self)
end

-- This function establishes the relationship between this object (a minor)
-- and its parent (the major).
function Moveable:set_role(args)
    self.role.major = args.major or self
    self.role.role_type = args.role_type or 'Minor'
    self.role.offset = args.offset or {x=0, y=0}
end

-- This function is a helper for setting alignment within a parent.
function Moveable:set_alignment(args)
    self.alignment = {
        major = args.major,
        type = args.type,
        bond = args.bond,
        offset = args.offset
    }
end

-- This is the CORE of the animation system!
-- It's called every single frame for every moveable object.
function Moveable:move(dt)

    -- The smooth easing animation only runs if the object is NOT being dragged.
    if not self.states.drag.is then
        -- Calculate the difference (the vector) between where the object SHOULD BE (T.x)
        -- and where it CURRENTLY IS on screen (VT.x).
        local dx = self.T.x - self.VT.x
        local dy = self.T.y - self.VT.y

        -- Move the VISIBLE position (VT) a small fraction of the way towards the TARGET position (T).
        -- The number '7' is the "easing factor". A higher number means faster, snappier movement.
        -- A lower number means slower, smoother movement.
        self.VT.x = self.VT.x + dx * 7 * dt
        self.VT.y = self.VT.y + dy * 7 * dt
    else
        -- If it IS being dragged, we snap the visible position directly
        -- to the target position to ensure it follows the mouse perfectly.
        self.VT.x = self.T.x
        self.VT.y = self.T.y
    end

    -- Add the exact same logic for scale animation.
    local ds = self.T.scale - self.VT.scale
    self.VT.scale = self.VT.scale + ds * 7 * dt

    -- NEW: Add the exact same easing logic for rotation.
    local dr = self.T.r - self.VT.r
    self.VT.r = self.VT.r + dr * 7 * dt

    -- Update the visible width and height based on the current scale.
    self.VT.w = self.base_w * self.VT.scale
    self.VT.h = self.base_h * self.VT.scale

    -- If this object is a 'Glued' child, its position and size are controlled by its parent ('major').
    if self.role.role_type == 'Glued' then
        self.VT.x = self.role.major.VT.x
        self.VT.y = self.role.major.VT.y
        self.VT.w = self.role.major.VT.w
        self.VT.h = self.role.major.VT.h
        -- NEW: A glued child must also copy its parent's rotation.
        self.VT.r = self.role.major.VT.r
    end
end