-- mouse mode

local obj = {}

local flag = {
    move  = false,
    dist  = 5,
    left  = 0,
    right = 0,
    up    = 0,
    down  = 0
}

local keySetDefault = {
    up    = 'E',
    left  = 'S',
    down  = 'D',
    right = 'F',
    leftClick  = 'W',
    rightClick = 'R',
    scrollUp   = 'K',
    scrollDown = 'J'
}

local getX = function()
    return flag.dist * (flag.right - flag.left)
end

local getY = function()
    return flag.dist * (flag.down - flag.up)
end

function obj:init(key)

    local mouse_mode = hs.hotkey.modal.new()

    local mm = function(func)
        return function()
            func()
            mouse_mode.triggered = true
        end
    end

    local mouse_move_up = function(dist)
        return function()
            flag.up = dist
        end
    end
    local mouse_move_down = function(dist)
        return function()
            flag.down = dist
        end
    end
    local mouse_move_left = function(dist)
        return function()
            flag.left = dist
        end
    end
    local mouse_move_right = function(dist)
        return function()
            flag.right = dist
        end
    end

    local mouse_move = function(dir, dist)
        return function()
            flag[dir] = dist
        end
    end

    local mouse_off = function(dir, dist)
        return function()
            flag[dir] = 0
        end
    end

    mouse_mode:bind({}, keySetDefault.up, mm(mouse_move_up(1)), mm(mouse_move_up(0)), nil)
    mouse_mode:bind({}, keySetDefault.left, mm(mouse_move_left(1)), mm(mouse_move_left(0)), nil)
    mouse_mode:bind({}, keySetDefault.down, mm(mouse_move_down(1)), mm(mouse_move_down(0)), nil)
    mouse_mode:bind({}, keySetDefault.right, mm(mouse_move_right(1)), mm(mouse_move_right(0)), nil)

    mouse_mode:bind({}, ',', function() flag.dist = 1 end, function() flag.dist = 10 end, nil)
    mouse_mode:bind({}, '.', function() flag.dist = 1 end, function() flag.dist = 10 end, nil)
    mouse_mode:bind({}, '/', function() flag.dist = 1 end, function() flag.dist = 10 end, nil)
    mouse_mode:bind({}, ';', function() flag.dist = 1 end, function() flag.dist = 10 end, nil)

    local mouse_cmd_w = mm(mouse_move_up(9))
    local mouse_cmd_a = mm(mouse_move_left(9))
    local mouse_cmd_s = mm(mouse_move_down(9))
    local mouse_cmd_d = mm(mouse_move_right(9))

    local mouse_click_left = mm(function() hs.eventtap.leftClick(hs.mouse.getAbsolutePosition()) end)
    local mouse_click_right = mm(function() hs.eventtap.rightClick(hs.mouse.getAbsolutePosition()) end)
    local mouse_wheel_up = mm(function() hs.eventtap.scrollWheel({0,1}, {}, 'line') end)
    local mouse_wheel_down = mm(function() hs.eventtap.scrollWheel({0,-1}, {}, 'line') end)
    local mouse_wheel_up_slow = mm(function() hs.eventtap.scrollWheel({0,1}, {}, 'pixel') end)
    local mouse_wheel_down_slow = mm(function() hs.eventtap.scrollWheel({0,-1}, {}, 'pixel') end)

    local mouse_center = mm(function()
        local screen = hs.window.focusedWindow():frame()
        local pt = hs.geometry.rectMidPoint(screen)
        hs.mouse.setAbsolutePosition(pt)
    end)

    local mouse_screen_center = mm(function()
        local screen = hs.window.focusedWindow():screen()
        local pt = hs.geometry.rectMidPoint(screen:fullFrame())
        hs.mouse.setAbsolutePosition(pt)
    end)

    mouse_mode:bind({}, keySetDefault.leftClick, mouse_click_left, nil, mouse_click_left)
    mouse_mode:bind({}, keySetDefault.rightClick, mouse_click_right, nil, mouse_click_right)
    mouse_mode:bind({}, keySetDefault.scrollUp, mouse_wheel_up, nil, mouse_wheel_up)
    mouse_mode:bind({}, keySetDefault.scrollDown, mouse_wheel_down, nil, mouse_wheel_down)

    mouse_mode:bind({'shift'}, keySetDefault.scrollUp, mouse_wheel_up_slow, nil, mouse_wheel_up_slow)
    mouse_mode:bind({'shift'}, keySetDefault.scrollDown, mouse_wheel_down_slow, nil, mouse_wheel_down_slow)
    mouse_mode:bind({}, 'Z', mouse_center)
    mouse_mode:bind({'shift'}, 'Z', mouse_screen_center)

    local on_mouse_mode = function()
        mouse_mode.triggered = false
        mouse_mode:enter()

        flag.move = true

        hs.timer.doWhile(
            function() return flag.move end,
            function()
                point = hs.mouse.getRelativePosition()
                point.x = point.x + getX()
                point.y = point.y + getY()

                hs.mouse.setRelativePosition(point)
            end,
            0.005
        )
    end

    local off_mouse_mode = function()
        flag.move = false
        mouse_mode:exit()
    end

    hs.hotkey.bind({}, key, on_mouse_mode, off_mouse_mode)

end

return obj
