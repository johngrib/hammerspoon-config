
local left, right = 0, 1
local top, mid = 0, 1

local half_width, full_width = 2, 1
local half_height, full_height = 2, 1

local function move_win(xx, yy, ww, hh)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()
        f.x = max.x + max.w * xx
        f.y = max.y + max.h * yy
        f.w = max.w * ww
        f.h = max.h * hh
        win:setFrame(f, 0)
    end
end

local function move_win_relative(xx, yy)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local max = win:screen():frame()
        f.x = f.x + xx
        f.y = f.y + yy
        win:setFrame(f, 0)
    end
end

local function send_window_prev_screen()
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():previous()
    win:moveToScreen(nextScreen, 0)
end

local function send_window_next_screen()
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():next()
    win:moveToScreen(nextScreen, 0)
end

local function maximize()
    local win = hs.window.focusedWindow()
    win:maximize(0.01)
end

return {
    ['default']      = move_win(1/4, 0, 1/2, 1),
    ['left_bottom']  = move_win(0, 1/2, 1/2, 1/2),
    ['bottom']       = move_win(0, 1/2, 1, 1/2),
    ['right_bottom'] = move_win(1/2, 1/2, 1/2, 1/2),
    ['left']         = move_win(0, 0, 1/2, 1),
    ['full_screen']  = maximize,
    ['right']        = move_win(1/2, 0, 1/2, 1),
    ['left_top']     = move_win(0, 0, 1/2, 1/2),
    ['top']          = move_win(0, 0, 1, 1/2),
    ['right_top']    = move_win(1/2, 0, 1/2, 1/2),
    ['prev_screen']  = send_window_prev_screen,
    ['next_screen']  = send_window_next_screen,
    ['move']         = move_win,
    ['move_relative'] = move_win_relative,
}

