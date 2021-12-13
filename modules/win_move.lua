local function move_win(xx, yy, ww, hh)
    return function()
        local win = hs.window.focusedWindow()

        if win == nil then
            win = hs.window.frontmostWindow()
        end

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

local win_move = {
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

hs.hotkey.bind({'control', 'option'}, 'c', win_move.default)
hs.hotkey.bind({'control', 'option'}, 'e', win_move.move(0, 0, 2/3, 1))
hs.hotkey.bind({'control', 'option'}, 'r', win_move.move(1/6, 0, 4/6, 1))
hs.hotkey.bind({'control', 'option'}, 't', win_move.move(1/3, 0, 2/3, 1))
hs.hotkey.bind({'control', 'option'}, 'd', win_move.left)
hs.hotkey.bind({'control', 'option'}, 'g', win_move.right)
hs.hotkey.bind({'control', 'option'}, 'u', win_move.left_top)
hs.hotkey.bind({'control', 'option'}, 'i', win_move.right_top)
hs.hotkey.bind({'control', 'option'}, 'j', win_move.left_bottom)
hs.hotkey.bind({'control', 'option'}, 'k', win_move.right_bottom)
hs.hotkey.bind({'control', 'option'}, 'o', win_move.top)
hs.hotkey.bind({'control', 'option'}, 'l', win_move.bottom)
hs.hotkey.bind({'control', 'option'}, ',', win_move.prev_screen)
hs.hotkey.bind({'control', 'option'}, '.', win_move.next_screen)
hs.hotkey.bind({'control', 'option'}, 'return', win_move.full_screen)

