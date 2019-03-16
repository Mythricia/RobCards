-- luacheck: globals love
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
local phArt  = love.graphics.newImage(assets.."placeholder.png")

-- Replaces tags in layout with actual data from card definition
function CardParser.Parse(layout, def)
    local drawables = {}

    local lBody     = layout.body   or {width=400, height=600, tint = {}}
    local lShapes   = layout.shapes or {}
    local lText     = layout.text   or {} -- only used for defaults
    local lArt      = layout.art    or {} -- only used for defaults

    -- Only <text> and <art> have definition data
    local dText     = def.text  or {}
    local dArt      = def.art   or {}

    -- Some sensible default properties
    -- Check category _default exists, if not, create empty
    lBody._default  = lBody._default or {}
    lShapes._default= lShapes._default or {}
    lText._default  = lText._default or {}
    lArt._default   = lArt._default or {}


    local default = {
        -- Generic defaults
        x = (lBody.width)/2,
        y = (lBody.height)/2,
        width   = 100,
        height  = 50,
        rotation= 0,


        color = {
            text = {
                lText._default.color and lText._default.color[1] or 1,
                lText._default.color and lText._default.color[2] or 0,
                lText._default.color and lText._default.color[3] or 0,
                lText._default.color and lText._default.color[4] or 1
            },

            shape = {
                lShapes._default.color and lShapes._default.color[1] or 0.5,
                lShapes._default.color and lShapes._default.color[2] or 0.95,
                lShapes._default.color and lShapes._default.color[3] or 0.5,
                lShapes._default.color and lShapes._default.color[4] or 1
            },

            art = {
                lArt._default.tint and lArt._default.tint[1] or 1,
                lArt._default.tint and lArt._default.tint[2] or 1,
                lArt._default.tint and lArt._default.tint[3] or 1,
                lArt._default.tint and lArt._default.tint[4] or 1
            },

            body = {
                lBody._default.tint and lBody._default.tint[1] or 0.5,
                lBody._default.tint and lBody._default.tint[2] or 0.5,
                lBody._default.tint and lBody._default.tint[3] or 0.5,
                lBody._default.tint and lBody._default.tint[4] or 1
            }
        },

        -- <text> specific defaults
        align = lText._default.align or "left",
        wrap = lText._default.wrap or lBody.width,
        font = lText._default.font or nil,
        fontSize = lText._default.fontSize or 16,
        content = lText._default.content or "PLACEHOLDER_TEXT",

        -- <shape> defaults
        style = "fill",
        type = "rectangle",
        name = "TAG_NAME",
    }


    -- Set up <body>
    drawables.body =
    {
        width = lBody.width,
        height = lBody.height,
        tint = {
            lBody.tint and lBody.tint[1] or default.color.body,
            lBody.tint and lBody.tint[2] or default.color.body,
            lBody.tint and lBody.tint[3] or default.color.body,
            lBody.tint and lBody.tint[4] or default.color.body
        },
        image = (
        function()
            if love.filesystem.getInfo(assets..lBody.image) then
                return love.graphics.newImage(assets..lBody.image)
            else
                return nil
            end
        end)()
    }


    -- Set up <shapes>
    drawables.shapes = {}
    for tag, shape in pairs(lShapes) do
        drawables.shapes[tag] =
        {
            name    = shape.name or default.name,
            x       = shape.x or default.x,
            y       = shape.y or default.y,

            width   = shape.width or default.width,
            height  = shape.height or default.height,

            type    = shape.type or default.type,
            style   = shape.style or default.style,

            color   = {
                shape.color and shape.color[1] or default.color.shape[1],
                shape.color and shape.color[2] or default.color.shape[2],
                shape.color and shape.color[3] or default.color.shape[3],
                shape.color and shape.color[4] or default.color.shape[4],
            }

        }
    end


    -- Set up all <text>
    drawables.text = {}
    for tag, content in pairs(dText) do
        drawables.text[tag] =
        {
            x       = lText[tag].x or default.x,
            y       = lText[tag].y or default.y,
            align   = lText[tag].align or default.align,
            wrap    = lText[tag].wrap or default.wrap,

            color   = {
                lText[tag].color[1] or default.color.text[1],
                lText[tag].color[2] or default.color.text[2],
                lText[tag].color[3] or default.color.text[3],
                lText[tag].color[4] or default.color.text[4]
            },

            font    = lText[tag].font or default.font,
            fontSize= lText[tag].fontSize or default.fontSize,
            content = content or default.content,
        }
    end


    -- Set up all <art>
    drawables.art = {}
    for tag, art in pairs(dArt) do
        drawables.art[tag] =
        {
            name    = lArt[tag] or default.name,
            x       = lArt[tag].x or default.x,
            y       = lArt[tag].y or default.y,
            width   = lArt[tag].width or default.size,
            height  = lArt[tag].height or default.size,
            tint    = {
                lArt[tag].tint[1] or default.color.art[1],
                lArt[tag].tint[2] or default.color.art[2],
                lArt[tag].tint[3] or default.color.art[3],
                lArt[tag].tint[4] or default.color.art[4]
            },
        }

        local image = love.graphics.newImage(assets..art) or phArt

        drawables.art[tag].content = image
        drawables.art[tag].scaleX = drawables.art[tag].width / image:getWidth()
        drawables.art[tag].scaleY = drawables.art[tag].height / image:getHeight()
        drawables.art[tag].rotation = lArt[tag].rotation or default.rotation
    end

    return drawCard(drawables)
end

function CardParser.SaveAll(cardTable)
    -- Takes a table of card objects and saves all of them one by one, using
    -- saveCard(card)
end


function drawCard(drawable)
    -- Draw all the drawables to an offscreen canvas, effectively rendering the card
    -- Convert the Canvas to ImageData (or keep canvases? Not sure how that'drawable work with many cards)
    -- Return Image (^Canvas?) to Parse, who bundles it with metadata and returns it all to caller
    -- love.graphics.draw( drawable, x, y, rot, scalex, scaley, offx, offy, shearx, sheary )

    local canvas = love.graphics.newCanvas(drawable.body.width, drawable.body.height, {msaa=4})
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1,1,1,1)


    -- Render <body>
    if drawable.body.image then
        love.graphics.setColor(drawable.body.tint)
        love.graphics.draw(drawable.body.image, 0, 0)
    end


    -- Render art tags
    for k, v in pairs(drawable.art) do
        if v.content then
            print("Drawing "..k.."...")
            love.graphics.setColor(v.tint)
            love.graphics.draw(v.content, v.x, v.y, v.rotation, v.scaleX, v.scaleY)
        end
    end

    -- Render text tags
    -- Prepare default font, for now
    for k, v in pairs(drawable.text) do
        if v.content then
            print("Drawing "..k.."...")
            local font = love.graphics.setNewFont(v.fontSize)
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