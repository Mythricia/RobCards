-- RobCards card layout config, by mythricia@gmail.com --
-- For help / tutorial, see: https://mythricia.github.io/RobCards/tutorial.html
local CardLayout = {}

-- Layout example: Component card
---------------------------------
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
            x       = 15,
            y       = 50,
            width   = 370,
            height  = 260,
            color   = {0, 0, 1},
            -- Optional:
            corner  = 10, -- If defined, creates rounded corner with this radius. Useful for card outline shape.
            --weight  = 5,  -- If the shape uses the "outline" type, this is the thickness of the lines.
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
            type    = "line",
            vertices= {0,50, 400,50}, -- pairs of X and Y points to define a line. Can be several segments in a row, just keep adding points.
            weight  = 5, -- thickness of the line
            -- Optional:
            joints  = "none" or "miter" or "bevel", -- How line segments join together, if there are more than 1.
        },
        {
            name    = "somePolygon",
            type    = "polygon",
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
            fontSize    = 16,
            color   = {0, 0.75, 0},
            align   = "left",
        },

        -- Attack Names
        attack1 = {
            x       = 100,
            y       = 365,
            fontSize    = 16,
            color   = {0, 0, 0.75},
        },
        attack2 = {
            x       = 100,
            y       = 478,
            fontSize    = 16,
            color   = {0, 0, 0.75},
        },

        -- Attack descriptions
        attackDesc1 = {
            x       = 100,
            y       = 385,
            fontSize    = 16,
            color   = {0, 0.75, 0},
            align   = "left",
            wrap    = 200, -- How many pixels long the text can be, before wrapping to a new line. NOT A COORDINATE
        },
        attackDesc2 = {
            x       = 100,
            y       = 495,
            fontSize    = 16,
            color   = {0, 0.75, 0},
            align   = "left",
            wrap    = 200,
        },

        -- Heat Costs
        heatCost1 = {
            x       = 45,
            y       = 400,
            fontSize    = 24,
            color   = {1, 0, 0},
        },
        heatCost2 = {
            x       = 50,
            y       = 520,
            fontSize    = 24,
            color   = {1, 0, 0},
        },

        -- Attack Damages
        attackDamage1 = {
            x        = 325,
            y       = 400,
            fontSize    = 24,
            color   = {1, 0.25, 0},
            align = "center",
            wrap = 45
        },
        attackDamage2 = {
            x       = 340,
            y       = 520,
            fontSize    = 24,
            color   = {1, 0.25, 0},
        },

        -- Custom default values
        _default = {
            fontSize    = 16,
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