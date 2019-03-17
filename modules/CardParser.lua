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
local base = love.filesystem.getSourceBaseDirectory()
local assets

if love.filesystem.isFused() then
    assets = "assets/art/"
    local success = love.filesystem.mount(base, "assets")
    if not success then error("Encountered an unknown error trying to access game directory!") end
else
    assets = "/art/"
end

local phPath = "/placeholders/"
local phArt  = love.graphics.newImage(phPath.."placeholder.png")
local phBody = love.graphics.newImage(phPath.."placeholder_bg.png")
local MISSING_TEXT = "MISSING_TEXT"
local MISSING_NAME = "MISSING_NAME"

-- Replaces tags in layout with actual data from card definition
-- Also substitutes default values wherever possible
function CardParser.Parse(layout, def, name)
    local drawables = {name = name}

    local lBody     = layout.body   or {width=400, height=600, tint = {}}
    local lShapes   = layout.shapes or {}
    local lText     = layout.text   or {} -- only used for defaults
    local lArt      = layout.art    or {} -- only used for defaults

    -- Only <text> and <art> have definition data
    local dText     = def.text  or {}
    local dArt      = def.art   or {}

    -- Check category _default exists, if not, create empty
    lBody._default  = lBody._default or {}
    lShapes._default= lShapes._default or {}
    lText._default  = lText._default or {}
    lArt._default   = lArt._default or {}


    -- Some sensible default properties
    local default = {
        -- Generic defaults
        x       = (lBody.width)/2,
        y       = (lBody.height)/2,
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
        align   = lText._default.align or "left",
        wrap    = lText._default.wrap or lBody.width,
        font    = lText._default.font or nil,
        fontSize= lText._default.fontSize or 16,
        text    = lText._default.text or MISSING_TEXT,

        -- <shape> defaults
        style   = "fill",
        type    = "rectangle",
        name    = MISSING_NAME,
        corner  = lShapes._default.corner or 0,
        weight  = lShapes._default.weight or 5,
        joints  = lShapes._default.joints or "miter",
        vertices={0,0,lBody.width,lBody.height}
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
            if type(lBody.image)=="string" and love.filesystem.getInfo(assets..lBody.image) then
                return love.graphics.newImage(assets..lBody.image)
            else
                return phBody
            end
        end)()
    }

    -- TODO: Support drawing Layout-wide images? Not sure if that belongs in <shapes>
    -- Set up <shapes>
    drawables.shapes = {}
    for tag, shape in ipairs(lShapes) do -- NOTE: Forced to use ipairs here because of shapes being array. Meh?
        drawables.shapes[tag] =
        {
            name    = shape.name or (default.name.."#"..tag),
            x       = shape.x or default.x,
            y       = shape.y or default.y,

            width   = shape.width or default.width,
            height  = shape.height or default.height,

            type    = shape.type or default.type,
            style   = shape.style or default.style,

            weight  = shape.weight or default.weight,
            joints  = shape.joints or default.joints,
            corner  = shape.corner or default.corner,

            -- Needs a raw copy, since we modify the vertices array in rendering
            -- Probably not the most elegant workaround but it works for now
            vertices= {unpack(shape.vertices or default.vertices)},

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
    for tag, text in pairs(dText) do
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
            content = text or default.content,
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

        local image = (
        function()
            if type(art) =="string" and love.filesystem.getInfo(assets..art) then
                return love.graphics.newImage(assets..art)
            else
                return phArt
            end
        end)()

        drawables.art[tag].content = image
        drawables.art[tag].scaleX = drawables.art[tag].width / image:getWidth()
        drawables.art[tag].scaleY = drawables.art[tag].height / image:getHeight()
        drawables.art[tag].rotation = lArt[tag].rotation or default.rotation
    end

    return drawCard(drawables), drawables
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
    print(":: Rendering "..(drawable.name or "a card").."!")

    local canvas = love.graphics.newCanvas(drawable.body.width, drawable.body.height, {msaa=4})
    love.graphics.push("all")
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setColor(1,1,1,1)


    -- Render <body>
    print(":: Rendering <body>")
    love.graphics.setBlendMode("alpha", "premultiplied")
    if drawable.body.image then
        love.graphics.setColor(drawable.body.tint)
        love.graphics.draw(drawable.body.image, 0, 0)
    end
    love.graphics.setBlendMode("alpha")


    -- TODO: Probably want to name an enum of possible shapes, and use the shape.type to
    --       index into a table of functions to perform the drawing, yadda yadda...
    -- Render <shapes>
    print(":: Rendering <shapes>")
    for tag, shape in ipairs(drawable.shapes) do
        print("Drawing "..shape.name.."...")
        love.graphics.setColor(shape.color)
        love.graphics.setLineWidth(shape.weight)
        love.graphics.setLineJoin(shape.joints)

        local mode = shape.style == "outline" and "line" or "fill"

        if shape.type == "rectangle" then
            love.graphics.rectangle(mode, shape.x, shape.y, shape.width, shape.height, shape.corner)
        elseif shape.type == "circle" then
            love.graphics.circle(mode, shape.x, shape.y, shape.width/2)
        elseif shape.type == "line" then
            love.graphics.line(shape.vertices)
        elseif shape.type == "polygon" then
            -- Offset vertices by x,y
            for i=1, #shape.vertices, 2 do
                shape.vertices[i] = shape.vertices[i] + shape.x
                shape.vertices[i+1] = shape.vertices[i+1] + shape.y
            end
            love.graphics.polygon(mode, shape.vertices)
        else
            error("Shape Renderer::\nAttempted to render unknown shape type \""..shape.type.."\"!\n"..
            "Supported Shape Types are:\nrectangle\ncircle\nline\npolygon")
        end
    end


    -- Render art tags
    print(":: Rendering <art>")
    for tag, art in pairs(drawable.art) do
        if art.content then
            print("Drawing "..tag.."...")
            love.graphics.setColor(art.tint)
            love.graphics.draw(art.content, art.x, art.y, art.rotation, art.scaleX, art.scaleY)
        end
    end

    -- Render text tags
    -- Prepare default font, for now
    print(":: Rendering <text>")
    for tag, text in pairs(drawable.text) do
        if text.content then
            print("Drawing "..tag.."...")
            local font = love.graphics.setNewFont(text.fontSize)
            local txt  = love.graphics.newText(font)
            txt:setf(text.content, text.wrap, text.align)
            love.graphics.setColor(text.color)
            love.graphics.draw(txt, text.x, text.y)
        end
    end

    -- Save the canvas to Image and return it
    love.graphics.setCanvas()
    love.graphics.pop()
    print(":: Card finished rendering!")
    print("---------------------------")
    return canvas:newImageData()
end


function saveCard(card)
    -- Saves a card ImageData (or Canvas?) as .png to disk
end



return CardParser