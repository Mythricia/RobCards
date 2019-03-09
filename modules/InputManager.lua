--[[
Copyright 2019 mythricia@gmail.com
Love2D Input Stack Manager
You may use, distribute and modify this code freely,
as long as you include this ORIGINAL copyright notice.
]]--


-- InputManager handles all input, with action sets definable by the code utilizing it
local InputManager = {}

-- data
local keys = {}         -- Raw key state container
local actionTables = {} -- Action tables stack
local stackPointer      -- Points to the top of the stack

-- Do some basic initialization
stackPointer = 0   -- 0 means the stack is empty!

-- Special values can be included in your actionTable:
--      * "isBlocking": Boolean. If true, block all unregistered input at the InputManager level (Do not fall through the stack)
--      * "onPush": an action (function) to execute when the actionTable is firsh pushed onto the stack
--      * "onPop": an action (function) to execute when the actionTable is popped off the stack



-- This function accepts a new actionTable, and pushes it on top of the stack, and runs the onPush() function if there is one
function InputManager.PushActionTable(actionTable)
	if not actionTable or not (actionTable.name and type(actionTable.name) == "string") then
		print("LevelManager:: WARNING: Tried to push invalid / empty table on the stack!")
		return
	end

    -- First of all, check if we already have this table somewhere in the stack, and yell + bail if we do
    if stackPointer > 0 then
    	for k,v in pairs(actionTables) do
    		if v == actionTable then
    			print("InputManager:: WARNING: Tried to push already existing table on stack!!")
    			print("InputManager:: >> ["..(actionTable.name or "MISSING ACTION TABLE NAME").."] already exists at index "..k..", current stackPointer is ["..stackPointer.."]")
    			return
    		end
    	end
    end

    -- It's a new ActionTable, check if it has a Push function and run if it does
    if type(actionTable.onPush) == "function" then
    	actionTable.onPush()
    end

    -- Push a new ActionTable onto the stack, making it the active one
    stackPointer = stackPointer + 1
    actionTables[stackPointer] = actionTable
end


-- This function pops the topmost table off of the stack, and executes the onPop() function if there is one
function InputManager.PopActionTable()
    -- Pops the top ActionTable off the stack, making the next one active
    if stackPointer <= 0 then
        -- Just bail if there's nothing to pop
        print("LevelManager:: WARNING: Tried to call .PopActionTable(), but the stack is empty!")
        return
    end

    -- If the current ActionTable has an onPop() function, call it
    if type(actionTables[stackPointer].onPop) == "function" then
    	actionTables[stackPointer].onPop()
    end

    -- Decrement the stackPointer FIRST, so that if several Pops are in queue, they should not run into a null pointer
    stackPointer = stackPointer - 1

    if app.debugFlags["InputManager::printStackUpdates"] then
    	print("InputManager:: Popped table ["..(actionTables[stackPointer+1].name or "MISSING ACTION TABLE NAME").."] off the stack, stackPointer now at ["..stackPointer.."]")
    end

    -- Finally, pop the table off the stack
    table.remove(actionTables, stackPointer+1)
end


-- Utility function to get the current raw state of a key (using keyCodes).
function InputManager.getRawKeyState(key)
    -- Returns the current boolean state of any key
    if keys[key] then return keys[key] else return false end
end


-- keyChar is layout-dependent, keyCode is physically mapped to US layout
local function keyEvent(keyCode, direction)
    -- Update raw keymap
    keys[keyCode] = ((direction == "down" and true) or false)

    -- Bail early if the stack is empty
    if stackPointer <= 0 then
    	return
    end


    -- Start drilling down the stack looking for a matching action, starting at the top
    local actionFound = false;
    for i=stackPointer, 1, -1 do
    	local actionTable = actionTables[i]
        local isBlocking = actionTable.isBlocking or false   -- Set it for later

        if (not actionTable[keyCode]) then
            -- action not found in this table, skip

            if isBlocking then
                 -- current table is blocking! Break out
                 break
             end
        else -- action exists
        actionFound = true;

            -- execute Up or Down action, if it exists
            if direction == "down" then
            	if type(actionTable[keyCode].onKeyDown) == "function" then
            		actionTable[keyCode].onKeyDown()
            	end
            elseif direction == "up" then
            	if type(actionTable[keyCode].onKeyUp) == "function" then
            		actionTable[keyCode].onKeyUp()
            	end
            end
            break
        end
    end
end


-- Love2D keyboard hooks, this is where we capture the input.
function love.keypressed(keyChar, keyCode, isRepeat) -- luacheck: ignore
keyEvent(keyCode, "down")
end

function love.keyreleased(keyChar, keyCode, isRepeat) -- luacheck: ignore
keyEvent(keyCode, "up")
end


return InputManager