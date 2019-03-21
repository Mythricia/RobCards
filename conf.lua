-- THIS IS THE CONFIG FOR Love2D, touch at your own risk
-- luacheck: ignore
function love.conf(t)
    t.identity = "RobCards"

    t.appendidentity = true            -- Search files in source directory before save directory (boolean)

    t.modules.joystick = false           -- Enable the joystick module (boolean)
    t.modules.touch = false              -- Enable the touch module (boolean)

    t.console = true

    t.window.title = "Do Androids Dream of Electric Alpacas?"
    t.window.icon  = "icon.png"
    t.window.vsync = true
    t.window.width = 800
    t.window.height = 4 * (t.window.width / 3) -- Maintaining a 4:3 aspect ratio
    t.window.msaa = 8
    t.window.x = 50
    t.window.y = 50
    --t.window.fullscreen = true
end