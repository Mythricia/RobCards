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


function CardParser.Parse(layout, info)
    -- Create all the drawables based on layout and info
    -- call drawCard with these drawables
end

function CardParser.SaveAll(cardTable)
    -- Takes a table of card objects and saves all of them one by one, using
    -- saveCard(card)
end


function drawCard(drawables)
    -- Draw all the drawables to an offscreen canvas, effectively rendering the card
    -- Convert the Canvas to ImageData (or keep canvases? Not sure how that'd work with many cards)
    -- Return Image (^Canvas?) to Parse, who bundles it with metadata and returns it all to caller
end


function saveCard(card)
    -- Saves a card ImageData (or Canvas?) as .png to disk
end



return CardParser