-- luacheck: globals love
local InputManager = require("modules.InputManager")
local actionTable

local centerX = love.graphics.getWidth() / 2
local centerY = love.graphics.getHeight() / 2


local canvas
local font
local cmode = "normal"
local baseline
local image
local imageData

function love.load()
	InputManager.PushActionTable(actionTable)
	love.graphics.setBackgroundColor(0, 161/255, 241/255)

	local parser = require("modules.CardParser")
	local lay = require("CardLayout").Component
	local def = require("Cards").swordArm
	imageData = parser.Parse(lay, def)
	image = love.graphics.newImage(imageData)
end


function love.update(dt)
end

function love.draw()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.draw(image, centerX-200, centerY-300)
	love.graphics.print(love.mouse.getX()..","..love.mouse.getY(), 50, love.graphics.getHeight()-50)
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
			imageData:encode("png", "test_"..cmode..".png")
			love.system.openURL(love.filesystem.getSaveDirectory())
		end
	}
}
