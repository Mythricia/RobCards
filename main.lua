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
local fonts = {}
local cmode = "normal"

function love.load()
	InputManager.PushActionTable(actionTable)
	love.graphics.setBackgroundColor(0, 161/255, 241/255)


	canvas = love.graphics.newCanvas(400, 600, {msaa = 8, format=cmode})
     -- Rectangle is drawn to the canvas with the regular alpha blend mode.
    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('fill', 0, 0, 400, 600, 50)
	love.graphics.setCanvas()
end


function love.update(dt)
end

function love.draw()
	--love.graphics.setColor(0.75,0,0)

	-- very important!: reset color before drawing to canvas to have colors properly displayed
    -- see discussion here: https://love2d.org/forums/viewtopic.php?f=4&p=211418#p211418
    love.graphics.setColor(1, 1, 1, 1)

    -- The rectangle from the Canvas was already alpha blended.
    -- Use the premultiplied alpha blend mode when drawing the Canvas itself to prevent improper blending.
    love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(canvas, centerX-200, centerY-300)

	love.graphics.setBlendMode("alpha")
	love.graphics.printf("Some Darn Text", 0, centerY, love.graphics.getWidth(), 'center')

	love.graphics.polygon("fill", 100,100, 150,150, 100,200, 50,150, 100,100)
end

function love.mousepressed(x, y, button)
	--canvas:newImageData():encode("png", "test_"..cmode..".png")
	--love.system.openURL(love.filesystem.getSaveDirectory())
end

function love.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
end