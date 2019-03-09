-- luacheck: ignore
function love.conf(t)
    t.modules.joystick = false           -- Enable the joystick module (boolean)
    t.modules.touch = false              -- Enable the touch module (boolean)

    t.console = true

    t.window.vsync = true
    t.window.width = 1280
    t.window.height = 720
    --t.window.fullscreen = true
    t.window.msaa = 8
end