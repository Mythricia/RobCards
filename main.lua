-- luacheck: globals love
local InputManager = require("modules.InputManager")

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
}


local canvas
local font
local cmode = "normal"
local baseline
local image

function love.load()
	InputManager.PushActionTable(actionTable)
	love.graphics.setBackgroundColor(0, 161/255, 241/255)

	--image = love.graphics.newImage("/art/test.png")

	canvas = love.graphics.newCanvas(750, 1050, {msaa = 8, format=cmode})
	-- Rectangle is drawn to the canvas with the regular alpha blend mode.
	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(0.75, 0.15, 0.15)
	love.graphics.rectangle('fill', 0, 0, 750, 1050, 50)
	love.graphics.setCanvas()

	font = love.graphics.setNewFont(24)
	baseline = font:getBaseline()
end


function love.update(dt)
end

function love.draw()
	-- very important!: reset color before drawing to canvas to have colors properly displayed
	-- see discussion here: https://love2d.org/forums/viewtopic.php?f=4&p=211418#p211418
	love.graphics.setColor(1, 1, 1, 1)


	-- The rectangle from the Canvas was already alpha blended.
	-- Use the premultiplied alpha blend mode when drawing the Canvas itself to prevent improper blending.
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(canvas, centerX-200, centerY-300, 0, 0.5, 0.5)

	--[[
	-- Prepare for text
	love.graphics.setBlendMode("alpha")
	local cy = centerY+baseline+2

	love.graphics.setColor(0,0,0,0.75)
	love.graphics.line(centerX-200, cy, centerX+200, cy)
	love.graphics.line(centerX-200, cy+50, centerX+200, cy+50)
	love.graphics.line(centerX-200, cy+100, centerX+200, cy+100)
	love.graphics.line(centerX-200, cy+150, centerX+200, cy+150)

	love.graphics.setColor(0.75,0.75,0.75,1)
	love.graphics.printf("Centered Text", centerX-200, centerY, 400, 'center')
	love.graphics.printf("Spread Even Text", centerX-200, centerY+50, 400, 'justify')
	love.graphics.printf("Left Text", centerX-200, centerY+100, 400, 'left')
	love.graphics.printf("Right Text", centerX-200, centerY+150, 400, 'right')

	love.graphics.printf("Centered Very Long And Probably Wrapping Text", centerX-200, centerY+200, 400, 'center')
	]]
end

function love.mousepressed(x, y, button)
	--canvas:newImageData():encode("png", "test_"..cmode..".png")
	--love.system.openURL(love.filesystem.getSaveDirectory())
end

function love.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
end