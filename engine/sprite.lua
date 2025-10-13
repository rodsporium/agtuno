---@class Sprite: Moveable
-- Sprite inherits from Moveable. It gets all the properties of a Node AND a Moveable,
-- including both the 'T' and 'VT' tables.
Sprite = Moveable:extend()

-- This is the CONSTRUCTOR for Sprite.
function Sprite:init(args)
    -- First, call the constructor of the parent class (Moveable).
    -- This sets up the T and VT tables.
    Moveable.init(self, args)

    -- A Sprite needs to know which spritesheet to use.
    -- 'atlas' is a table containing the image and the dimensions of each sprite.
    self.atlas = args.atlas

    -- It also needs to know WHICH sprite to cut out from the sheet.
    -- 'sprite_pos' gives the {x, y} coordinates on the sprite grid.
    self.sprite_pos = args.sprite_pos or {x=0, y=0}

    -- A "Quad" is a LÖVE object that represents a rectangular piece of an image.
    -- We create a quad that perfectly cuts out the single card sprite we want
    -- from the larger atlas image.
    self.quad = love.graphics.newQuad(
        self.sprite_pos.x * self.atlas.px, -- The top-left x pixel on the atlas
        self.sprite_pos.y * self.atlas.py, -- The top-left y pixel on the atlas
        self.atlas.px,                     -- The width of the sprite in pixels
        self.atlas.py,                     -- The height of the sprite in pixels
        self.atlas.image:getDimensions()   -- The dimensions of the whole atlas image
    )

    -- We add this new sprite to a global list so our love.draw function can find it.
    G.I.SPRITE = G.I.SPRITE or {}
    table.insert(G.I.SPRITE, self)
end

-- This is the DRAWER for a Sprite. It overrides the empty Node:draw().
function Sprite:draw()
    -- First, call the original Node:draw() function. This is good practice
    -- because it will draw any children this sprite might have.
    Node.draw(self)

    love.graphics.setColor(1, 1, 1, 1) -- Set color to white (no tint)

    -- This is the most important drawing command.
    -- It tells LÖVE to draw a specific piece of an image (the quad)
    -- at a specific location on the screen.
    love.graphics.draw(
        self.atlas.image,  -- The full spritesheet image
        self.quad,         -- The specific rectangular piece to cut out and draw
        self.VT.x,         -- The VISIBLE x-position on the screen
        self.VT.y,         -- The VISIBLE y-position on the screen
        self.VT.r,         -- The VISIBLE rotation
        self.VT.w / self.atlas.px, -- The scale factor for the width
        self.VT.h / self.atlas.py,  -- The scale factor for the height
        self.atlas.px / 2, -- NEW: Set the origin to the center for proper rotation
        self.atlas.py / 2  -- NEW: Set the origin to the center for proper rotation
    )

    -- NEW: Call the troubleshooter function to draw the bounding box.
    self:draw_boundingrect()
end
