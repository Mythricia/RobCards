--[[ RobCards card parser, by mythricia@gmail.com ]]--
-- Takes a CardLayout and a Card definition, and returns
-- an object that contains a rendered image of the card,
-- as well as a table of meta information for later use
-- (card stats, etc).

-- CardLayout describes where things are rendered and how
-- Card definition describes the text strings and art


local CardParser = {}
local drawCard
local saveCard

-- constants
local assets = "/art/"
local phText = "PLACEHOLDER TEXT"
local phArt  = {}
phArt.img = love.graphics.newImage(assets.."placeholder.png")

function CardParser.Parse(layout, def)
    -- Replaces tags in layout with actual data from card definition
    local body = layout.body
    local shapes = layout.shapes
    local text = def.text
    local art = def.art

    local drawables = {}

    -- Set up <body>
    drawables.body =
    {
        width = body.width,
        height = body.height,
        tint = {body.tint[1], body.tint[2], body.tint[3], body.tint[4]},
        image = (
        function()
            if love.filesystem.getInfo(assets..body.image) then
                return love.graphics.newImage(assets..body.image)
            else
                return nil
            end
        end)()
    }

    -- Prepare <text> _defaults
    local d = layout.text._default
    d =
    {
        x = d.pos[1],
        y = d.pos[2],
        size = d.size,

        color = {
            d.color[1],
            d.color[2],
            d.color[3],
            d.color[4]
        },

        align = d.align,
        wrap = d.wrap
    }

    -- Set up all <text>
    drawables.text = {}
    for k, v in pairs(text) do
        drawables.text[k] =
        {
            x = layout.text[k].pos[1] or d.x,
            y = layout.text[k].pos[2] or d.y,
            size = layout.text[k].size or d.size,
            align = layout.text[k].align or d.align,
            wrap = layout.text[k].wrap or d.wrap,

            color =
            {
                layout.text[k].color[1] or d.color.r,
                layout.text[k].color[2] or d.color.g,
                layout.text[k].color[3] or d.color.b,
                layout.text[k].color[4] or d.color.a
            },

            font = layout.text[k].font,
            content = v or phText,
        }
    end

    -- Set up all <art>
    drawables.art = {}
    for k, v in pairs(art) do
        drawables.art[k] =
        {
            name = layout.art[k].name,
            x = layout.art[k].pos[1] or 0,
            y = layout.art[k].pos[2] or 0,
            width = layout.art[k].width or 100,
            height = layout.art[k].height or 100,
            tint = layout.art[k].tint or {1,1,1,1}
        }

        local content = love.graphics.newImage(assets..v) or phArt.img

        drawables.art[k].content = content
        drawables.art[k].scaleX = drawables.art[k].width / content:getWidth()
        drawables.art[k].scaleY = drawables.art[k].height / content:getHeight()
        drawables.art[k].rotation = layout.art[k].rotation or 0
    end

    return drawCard(drawables)
end

function CardParser.SaveAll(cardTable)
    -- Takes a table of card objects and saves all of them one by one, using
    -- saveCard(card)
end


function drawCard(d)
    -- Draw all the drawables to an offscreen canvas, effectively rendering the card
    -- Convert the Canvas to ImageData (or keep canvases? Not sure how that'd work with many cards)
    -- Return Image (^Canvas?) to Parse, who bundles it with metadata and returns it all to caller
    -- love.graphics.draw( drawable, x, y, rot, scalex, scaley, offx, offy, shearx, sheary )

    local canvas = love.graphics.newCanvas(d.body.width, d.body.height, {msaa=4})
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1,1,1,1)


    -- Render <body>
    if d.body.image then
        love.graphics.setColor(d.body.tint)
        love.graphics.draw(d.body.image, 0, 0)
    end


    -- Render art tags
    for k, v in pairs(d.art) do
        if v.content then
            print("Drawing "..k.."...")
            love.graphics.setColor(v.tint)
            love.graphics.draw(v.content, v.x, v.y, v.rotation, v.scaleX, v.scaleY)
        end
    end

    -- Render text tags
    -- Prepare default font, for now
    for k, v in pairs(d.text) do
        if v.content then
            print("Drawing "..k.."...")
            local font = love.graphics.setNewFont(v.size)
            local txt  = love.graphics.newText(font)
            txt:setf(v.content, v.wrap, v.align)
            love.graphics.setColor(v.color)
            love.graphics.draw(txt, v.x, v.y)
        end
    end

    -- Save the canvas to Image and return it
    love.graphics.setCanvas()
    return canvas:newImageData()
end


function saveCard(card)
    -- Saves a card ImageData (or Canvas?) as .png to disk
end



return CardParser