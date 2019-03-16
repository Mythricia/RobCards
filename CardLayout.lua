--[[ RobCards card layout config, by mythricia@gmail.com ]]--

--[[ Layouts are defined as such:

Each layout has a name. This name is simply the name of the table.
Inside this layout, are some sub-tables. These table names are CaSe SeNsItIvE!

<body>
Simply describes the exact size of the card, as well as a background color or image, if any (optional).
Setting an image AND a color, will tint the image. To avoid tint, just omit the color, or set it to white (1,1,1,1).
The main purpose of the body is to simply define the "container" for the card type.
In a future version, the body will let you define the cutout shape for a card type.
This would let you make, for example, rounded corners. Or any other shape. Not yet, because stencil code makes my head hurt

<shapes>
Describes the layout of rectangles, lines, circles, or polygons, or images that you want to draw.
Images will be the exact same for every variant of the card, so this is NOT for individual card art.
Shapes can choose between two styles: "fill" or "outline".
Shape are rendered in order from top to bottom.
Shape names are, for now, ignored, but you can use them to keep track of what's what.
Legal shape types are: "rectangle", "circle", "line" and "polygon".


<text>
Describes the layout (BUT NOT THE DATA) for the text you want to show on the card,
including position, color, size, alignment (left, right, center).
Eventually support different fonts for different texts, but not right now.


<art>
Describes the location and size of art images. This is where you would define things
such as unique center card art, or perhaps icons for damage types, or small art details in general.
All art is drawn as rectangles. If you want more complex shapes, use transparency in your art.
Art name attributes are only really used for placeholders if your art file is missing or broken.
Width and Height for art is optional; if omitted, the image will be drawn straight to the screen.
If you define width and height, the image will be stretched to fit. Aspect Ratio will not be maintained.
Scaling an image may lead to blur or aliasing.
Highly recommend you create the source art in the correct dimensions instead, and draw them unscaled.


-- Notes --
About colors:
The format for color attributes is {R,G,B,A}, from 0 to 1, and the last one, Alpha, is optional.

About positions:
Shape and image sizes and positions are clamped to the size of the card body, as much as possible.
That means if you try to place a shape or image or text outside the body, it will clamp inside.
Likewise if you try to create a shape that is too wide, it will clamp to fit inside the body.
If this clamping is unnecessary, just talk to me, I can change how it works and remove the clamping,
allowing you to create horrible glitch monsters to your hearts content!


There is a special _default tag for <text> and <shapes>, that defines some default values.
This can be used if you want to, for example, default to a custom font, instead of
the Love2D default font. Or, if you want all shapes to default to a certain color, etc.


Layout example: Component card
------------------------------]]
local CardLayout = {} -- This table holds ALL the different card layouts.


CardLayout.Component = {
    --:: Body
    body = {
        width   = 400,
        height  = 600,
        tint    = {1, 1, 1, 1}, -- Tinting the background image
        image   = "placeholder_bg.png", -- Relative to the 'art' folder
        cutout  = "cutoutMask.png",  -- NYI: Some time in the future this might work. Right now it does nothin'.
    },

    --:: Shapes
    shapes = {
        {
            name    = "someDarnRectangle",
            type    = "rectangle",
            style   = "fill",
            x       = 10,
            y       = 50,
            width   = 380,
            height  = 265,
            color   = {1, 1, 1},
            -- Optional:
            corner  = 10, -- If defined, creates rounded corner with this radius. Useful for card outline shape.
        },
        {
            name    = "someCircle",
            type    = "circle",
            style   = "outline",
            x       = 200,
            y       = 300, -- CENTERPOINT of the circle.
            width  = 100,
        },
        {
            name    = "someLine",
            vertices= {0,50, 400,50}, -- pairs of X and Y points to define a line. Can be several segments in a row, just keep adding points.
            width   = 5,
            -- Optional:
            joints  = "none" or "miter" or "bevel", -- How line segments join together, if there are more than 1.
        },
        {
            name    = "somePolygon",
            style   = "fill",
            vertices= {100,100, 150,150, 100,200, 50,150, 100,100},
            color   = {1, 0, 0},
            -- Optional:
            x       = 200,-- If defined, x and y will be used to offset all the vertices.
            y       = 450,
        },
    },

    --:: Text
    text = {
        -- Name of the card
        name = {
            x       = 15,
            y       = 20,
            color   = {0, 0, 0},
        },

        -- Augment count
        augs = {
            x       = 140,
            y       = 20,
            color   = {0.1, 0.1, 0.1},
        },

        -- Stats
        stats = {
            x       = 0,
            y       = 20,
            color   = {0.5, 0.5, 0},
            align = "right",
            wrap = 385
        },

        -- Card Type desc
        cardType    = {
            x       = 15,
            y       = 335,
            size    = 16,
            color   = {0, 0.75, 0},
            align   = "left",
        },

        -- Attack Names
        attack1 = {
            x       = 100,
            y       = 365,
            size    = 16,
            color   = {0, 0, 0.75},
        },
        attack2 = {
            x       = 100,
            y       = 478,
            size    = 16,
            color   = {0, 0, 0.75},
        },

        -- Attack descriptions
        attackDesc1 = {
            x       = 100,
            y       = 385,
            size    = 16,
            color   = {0, 0.75, 0},
            align   = "left",
            wrap    = 200, -- How many pixels long the text can be, before wrapping to a new line. NOT A COORDINATE
        },
        attackDesc2 = {
            x       = 100,
            y       = 495,
            size    = 16,
            color   = {0, 0.75, 0},
            align   = "left",
            wrap    = 200,
        },

        -- Heat Costs
        heatCost1 = {
            x       = 45,
            y       = 400,
            size    = 24,
            color   = {1, 0, 0},
        },
        heatCost2 = {
            x       = 50,
            y       = 520,
            size    = 24,
            color   = {1, 0, 0},
        },

        -- Attack Damages
        attackDamage1 = {
            x        = 325,
            y       = 400,
            size    = 24,
            color   = {1, 0.25, 0},
            align = "center",
            wrap = 45
        },
        attackDamage2 = {
            x       = 340,
            y       = 520,
            size    = 24,
            color   = {1, 0.25, 0},
        },

        -- Custom default values
        _default = {
            size    = 16,
            align   = "left",
        },
    },

    --:: Art
    art = {
        centerArt = {
            name    = "CENTER CARD ART",
            x       = 10,
            y       = 45,
            width   = 380,
            height  = 270,
            tint    = {1,1,1,0.75}
        },

    }
}



-- Return the table
return CardLayout