--[[ RobCards card layout config, by mythricia@gmail.com ]]--
local Layouts = {} -- This table holds ALL the different card layouts.

--[[ Layouts are defined as such:

Each layout has a name. This name is simply the name of the table.
Inside this layout, are some sub-tables. Their names are case sensitive.

<body>
Simply describes the exact size of the card, as well as a background color, if any (optional).
In the future, this will be where you drop an image file name to get card background art.
This does not actually draw any graphics at all. It simply defines the "container" for the card.

<shapes>
Describes the layout of rectangles, lines, circles, or polygons, or images that you want to draw.
Shapes can choose between two styles: "fill" or "line". Solid shape vs outline.
Shape are rendered in order from top to bottom.
Shape names are, for now, ignored, but you can use them to keep track of what's what.
Legal shape types are: "rectangle", "circle", "line" and "polygon".


<tags>
Describes the layout (BUT NOT THE DATA) for the TEXT you want to show on the card,
including position, color, size.


One note about colors:
The format is {R,G,B,A}, from 0 to 1, and the last one, Alpha, is optional. Defaults to opaque (1).

One note about positions:
Shape and tag sizes and positions are clamped to the size of the card body.
That means if the body is 200w x 200h, and you try to place a tag at x=400, it will clamp to 200.
Likewise if you try to create a shape that is 400 pixels wide, it will clamp to fit inside the body.
If this clamping is unnecessary, just talk to me, I can change how it works and remove the clamping,
allowing you to create horrible glitch monsters to your hearts content!


Layout example:
---------------

local SomeCardTypeName = {
    body = {
        width   = 400,
        height  = 600,
        color   = {1,0,0}
        image   = "/someFolder/someArt.png" -- Relative to the 'art' folder. In this case, 'someFolder' is inside /art/.
    },

    shapes = {
        {
            name    = "someDarnRectangle"
            type    = "rectangle",
            style   = "fill",
            pos     = {0, 0},   -- TOPLEFT of rectangle.
            width   = 400,
            height  = 600,
            color   = {1,1,1},
            -- Optional:
            corner  = 10,   -- If defined, creates rounded corner with this radius. Useful for card outline shape.
        },
        {
            name    = "someCircle"
            type    = "circle",
            style   = "line",
            pos     = {0, 0},   -- CENTERPOINT of the circle.
            radius  = 100,
        },
        {
            name    = "someLine",
            vertices= {0,0, 20,20}, -- pairs of X and Y points to define a line. Can be several segments in a row, just keep adding points.
            width   = 5,
            -- Optional:
            joints  = "none" or "miter" or "bevel",     -- How line segments join together, if there are more than 1.
        },
        {
            name    = "somePolygon",
            style   = "fill",
            vertices= {100,100, 150,150, 100,200, 50,150, 100,100},
            color   = {0,1,0},
            -- Optional:
            pos     = {0,0},    -- If pos is defined, it will be used to offset all the coordinates listed in the 'vertices' above.
        }
    }

    tags = {
        tag     = value,
        tag2    = value2,
        tagEtc  = valueEtc,
    },




}

--]]




-- Position coordinates are in pixels {x, y} relative to the card's top-left corner.
-- Each "tag" describes a piece of text somewhere on the card.
-- Each tag has 2 attributes:
-- * position:  {x = 0, y = 0},     -- Where this tag starts.
-- * color:     {1,1,1,1},          -- R,G,B,Alpha, values 0<->1 (or 0-255, both works because of magic)
-- * size:      16,                 -- Font size
-- Tags are CaSe SeNsItIvE



-- We define each different card type layout below. For now, just Component cards.
local Component = {
    name = "test"
}

































return Layouts