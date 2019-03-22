-- luacheck: globals love
local InputManager = require("modules.InputManager")
local actionTable

local centerX = love.graphics.getWidth() / 2
local centerY = love.graphics.getHeight() / 2


local canvas
local font
local cmode = "normal"
local baseline
local error
local cards = {}

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

	love.graphics.setColor(1, 1, 1, 1)
	local drawCardX = centerX-(cards[imageIndex].image:getWidth() / 2)
	local drawCardY = centerY-(cards[imageIndex].image:getHeight() / 2)

	love.graphics.draw(cards[imageIndex].image, drawCardX, drawCardY)

	local indexText = (imageIndex.."/"..#cards.." ("..cards[imageIndex].metadata.name..")")
	love.graphics.print(indexText, 15,15)


	if love.mouse.isDown(1) then
		local mouseX, mouseY = love.mouse.getPosition()

		local cardX = mouseX - drawCardX
		local cardY = mouseY - drawCardY

		love.graphics.setColor(1,0,0,1)
		love.graphics.circle("fill", mouseX, mouseY, 3)
		love.graphics.print("Card Coords: "..cardX..","..cardY, mouseX+15, mouseY+15, 0, 1.5)
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
		end
	},
	['escape'] =
	{
		onKeyDown = function()
			love.event.quit()
		end
	},
	['r'] =
	{
		onKeyDown = function()
			love.event.quit("restart")
		end
	},
	['space'] =
	{
		onKeyDown = function()
			print("Saving card to disk.....")
			cards[imageIndex].imagedata:encode("png", cards[imageIndex].metadata.name..".png")
			love.system.openURL(love.filesystem.getSaveDirectory())
		end
	},
	['right'] =
	{
		onKeyDown = function()
			imageIndex = imageIndex + 1
			if imageIndex > #cards then imageIndex = 1 end
		end
	},
	['left'] =
	{
		onKeyDown = function()
			imageIndex = imageIndex - 1
			if imageIndex < 1 then imageIndex = #cards end
		end
	},
}
