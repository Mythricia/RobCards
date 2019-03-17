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
	love.graphics.setBackgroundColor(0, 161/255, 241/255)

	local parser = require("modules.CardParser")
	local s1, layouts = pcall(require, "CardLayout")
	local s2, definitions = pcall(require, "Cards")

	if s1 and s2 then
		local n = 0
		for k,v in pairs(definitions) do
			if layouts[v.layout] then
				n = n + 1
				local imageData, metadata = parser.Parse(layouts[v.layout], v, v.layout.."."..k)
				local image = love.graphics.newImage(imageData)
				cards[n] = {imagedata=imageData, image=image, metadata = metadata}
			end
		end
	end
end


function love.update(dt)
end

function love.draw()
	if #cards < 1 then
		love.graphics.print("Nothing to draw!\nEdit CardLayout.lua and Cards.lua", 50,50)
		return
	end

	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(1, 1, 1, 1)
	local drawCardX = centerX-200
	local drawCardY = centerY-300

	love.graphics.draw(cards[imageIndex].image, drawCardX, drawCardY)

	local indexText = (imageIndex.."/"..#cards.." ("..cards[imageIndex].metadata.name..")")
	love.graphics.print(indexText, 15,15)


	if love.mouse.isDown(1) then
		love.graphics.print("Screen Coords: "..love.mouse.getX()..","..love.mouse.getY(), 50, love.graphics.getHeight()-50)

		local cardX = love.mouse.getX() - drawCardX
		local cardY = love.mouse.getY() - drawCardY

		local cardX = (cardX >= 0 and cardX or 0)
		local cardY = (cardY >= 0 and cardY or 0)

		local cardX = (cardX <= 400 and cardX or 400)
		local cardY = (cardY <= 600 and cardY or 600)

		love.graphics.setColor(1,0,0,1)
		love.graphics.print("Card Coords: "..cardX..","..cardY, love.mouse.getX()+15, love.mouse.getY()+15)
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
			imagedata:encode("png", "test_"..cmode..".png")
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
