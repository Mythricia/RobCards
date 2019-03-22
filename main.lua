-- luacheck: globals love
local InputManager = require("modules.InputManager")
local actionTable

-- Forward function decs
local drawKeyHelper
local drawMouseHelper
local saveSingleCard
local saveAllCards

local centerX = love.graphics.getWidth() / 2
local centerY = love.graphics.getHeight() / 2

local error
local cards = {}
local drawKeys = true

local imageIndex = 1

function love.load()
	InputManager.PushActionTable(actionTable)
	love.graphics.setBackgroundColor(0, 0, 0)

	local parser = require("modules.CardParser")
	local e1, layouts = pcall(require, "CardLayout")
	local e2, definitions = pcall(require, "Cards")

	if e1 and e2 then
		local n = 0
		for k,v in pairs(definitions) do
			if layouts[v.layout] then
				n = n + 1
				local imageData, metadata = parser.Parse(layouts[v.layout], v, v.layout.."."..k)
				local image = love.graphics.newImage(imageData)
				cards[n] = {imagedata=imageData, image=image, metadata = metadata}
			end
		end
	else
		error = {}
		if not e1 then
			error.layout = layouts
		end
		if not e2 then
			error.cards = definitions
		end
	end
end


function love.update(dt)
end

function love.draw()
	if #cards < 1 then
		if error then
			love.graphics.print("There were errors trying to load " .. (error.layout and "CardLayout.lua:" or "Cards.lua:"), 25,25)
			love.graphics.printf(error.layout or error.cards, 25, 50, love.graphics.getWidth()-50)
		else
			love.graphics.print("Nothing to draw!\nEdit CardLayout.lua and Cards.lua", 50,50)
		end
		return
	end

	local cardWidth, cardHeight = cards[imageIndex].image:getDimensions()
	local drawCardX = centerX-(cardWidth / 2)
	local drawCardY = centerY-(cardHeight / 2)

	do -- Card drawing section
		-- draw card bounds outline
		love.graphics.setColor(0,1,0,0.25)
		love.graphics.rectangle("line", drawCardX, drawCardY, cardWidth, cardHeight)

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(cards[imageIndex].image, drawCardX, drawCardY)

		local indexText = (imageIndex.."/"..#cards.." ("..cards[imageIndex].metadata.name..")")
		love.graphics.print(indexText, 15,15)
	end

	-- Card coord helper
	if love.mouse.isDown(1) then
		drawMouseHelper(drawCardX, drawCardY, cardWidth, cardHeight)
	end


	-- Draw keybindings, if drawKeys is true
	if drawKeys then
		drawKeyHelper()
	end
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
end


actionTable = {
	name = "default",

	['q'] =
	{
		onKeyDown = function()
			love.event.quit()
		end,
		label = "Quit"
	},
	['escape'] =
	{
		onKeyDown = function()
			love.event.quit()
		end,
		label = "Quit"
	},
	['r'] =
	{
		onKeyDown = function()
			love.event.quit("restart")
		end,
		label = "Reload"
	},
	['space'] =
	{
		onKeyDown = function()
			print("Saving card to disk...")
			saveSingleCard(imageIndex)
		end,
		label = "Save to disk"
	},
	['right'] =
	{
		onKeyDown = function()
			imageIndex = imageIndex + 1
			if imageIndex > #cards then imageIndex = 1 end
		end,
		label = "Browse ->"
	},
	['left'] =
	{
		onKeyDown = function()
			imageIndex = imageIndex - 1
			if imageIndex < 1 then imageIndex = #cards end
		end,
		label = "Browse <-"
	},
	['h'] =
	{
		onKeyDown = function()
			drawKeys = not drawKeys
		end,
		label = "Toggle this help"
	},
	['Left Click (Hold)'] =
	{
		-- Fake keybind, doesn't work with InputManager
		label = "Card coordinates"
	},
	['p'] = {
		onKeyDown = function()
			saveAllCards()
		end,
		label = "Save ALL to disk"
	}
}


function drawKeyHelper()
	love.graphics.setColor(1,1,1,1)
	local t = {}
	for k,v in pairs(actionTable) do
		if v.label then
			t[v.label] = t[v.label] or {}
			table.insert(t[v.label], k)
		end
	end


	local n = 1
	for k,v in pairs(t) do

		local str = v[1]
		if #v > 1 then
			for i=2,#v do
				str = str.." / "..v[i]
			end
		end

		n = n + 1

		str = string.upper(str)..": "..k
		love.graphics.print(str, 10, love.graphics.getHeight()-20*n)
	end
end

function drawMouseHelper(drawX, drawY, width, height)
	local mouseX, mouseY = love.mouse.getPosition()

	local cardX = math.floor(math.clamp(mouseX - drawX, 0, width))
	local cardY = math.floor(math.clamp(mouseY - drawY, 0, height))
	local str = "Card Coords: "..cardX..","..cardY

	local font = love.graphics.newFont(20)
	str = love.graphics.newText(font, str)

	love.graphics.setColor(0,0,0,0.85)
	love.graphics.rectangle("fill", mouseX-100, mouseY+17, 225, 19)

	love.graphics.setColor(1,0,0,1)
	love.graphics.circle("fill", mouseX, mouseY, 3)
	love.graphics.draw(str, mouseX-100, mouseY+15)
end


function math.clamp(val, lower, upper)
	assert(val and lower and upper, "math.Clamp:: Wrong number of arguments")
	if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
	return math.max(lower, math.min(upper, val))
end


function saveSingleCard(index)
	cards[index].imagedata:encode("png", cards[imageIndex].metadata.name..".png")
	love.system.openURL(love.filesystem.getSaveDirectory())
end

function saveAllCards()
	for i,v in ipairs(cards) do
		print("Saving card #"..i.."...")
		v.imagedata:encode("png", v.metadata.name..".png")
	end

	love.system.openURL(love.filesystem.getSaveDirectory())
end