-- luacheck: globals love
local InputManager = require("modules.InputManager")
local socket = require "socket"

local centerX = love.graphics.getWidth() / 2
local centerY = love.graphics.getHeight() / 2


local actionTable = {
	name = "default",

	['q'] =
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
}


function love.load()
	InputManager.PushActionTable(actionTable)
	love.graphics.setBackgroundColor(0, 161/255, 241/255)
end


function love.update(dt)
end

function love.draw()
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
end