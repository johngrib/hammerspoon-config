-- hammerspoon config

-- require('luarocks.loader')
-- require('modules.mouse'):init('f16')
local inputEnglish = "com.apple.keylayout.ABC"
local inputKorean = "org.youknowone.inputmethod.Gureum.han2"

local win_move = require('modules.winmove')
local app_man = require('modules.appman')

local vim_mode = hs.hotkey.modal.new()
local app_mode = hs.hotkey.modal.new()

local vimlike = require('modules.vim'):init(vim_mode)

hs.window.animationDuration = 0

hs.hotkey.bind({}, 'f17', function() app_mode:enter() end, function() app_mode:exit() end)

local maccy = function()
    -- maccy 는 단축키 조합에 f1 ~ f20 이 들어가면 인식을 못한다.
    hs.eventtap.keyStroke({'command', 'shift', 'option', 'control'}, 'c')
end

hs.hotkey.bind({'shift'}, 'f14', maccy) -- for maccy

function setVimlikeKey(keyCode)
    local vimlikeKey = keyCode
    hs.hotkey.bind({}, vimlikeKey, vimlike.on, vimlike.off)
    hs.hotkey.bind({'cmd'}, vimlikeKey, vimlike.on, vimlike.off)
    hs.hotkey.bind({'shift'}, vimlikeKey, vimlike.on, vimlike.off)

    vim_mode:bind({}, 'q', hs.caffeinate.systemSleep, vimlike.close)
    vim_mode:bind({'shift'}, 'r', hs.reload, vimlike.close)
    vim_mode:bind({}, 'a', function()
        local activeAppName = hs.application.frontmostApplication():name()
        hs.alert.show(activeAppName)
    end, vimlike.close)

    vim_mode:bind({}, 'c', maccy, vimlike.close)
    vim_mode:bind({}, 'n', app_man:toggle('Notion'), vimlike.close)
    vim_mode:bind({}, 'm', app_man:toggle('Google Meet'), vimlike.close)
    vim_mode:bind({}, 'd', app_man:toggle('dictionary'), vimlike.close)
    vim_mode:bind({}, 'p', app_man:toggle('Postman'), vimlike.close)
end

do  -- vimlike
    setVimlikeKey('f13')
    -- setVimlikeKey('f16')
end

do  -- tab move
    local tabTable = {}

    tabTable['Slack'] = {
        left = { mod = {'option'}, key = 'up' },
        right = { mod = {'option'}, key = 'down' }
    }
    tabTable['Safari'] = {
        left = { mod = {'control', 'shift'}, key = 'tab' },
        right = { mod = {'control'}, key = 'tab' }
    }
    tabTable['터미널'] = {
        left = { mod = {'control', 'shift'}, key = 'tab' },
        right = { mod = {'control'}, key = 'tab' }
    }
    tabTable['Terminal'] = {
        left = { mod = {'control', 'shift'}, key = 'tab' },
        right = { mod = {'control'}, key = 'tab' }
    }
    tabTable['iTerm2'] = {
        left = { mod = {'shift', 'command'}, key = '[' },
        right = { mod = {'shift', 'command'}, key = ']' }
    }
    tabTable['IntelliJ IDEA'] = {
        left = { mod = {'command', 'shift'}, key = '[' },
        right = { mod = {'command', 'shift'}, key = ']' }
    }
    tabTable['PhpStorm'] = {
        left = { mod = {'command', 'shift'}, key = '[' },
        right = { mod = {'command', 'shift'}, key = ']' }
    }
    tabTable['Code'] = {
        left = { mod = {'command', 'shift'}, key = '[' },
        right = { mod = {'command', 'shift'}, key = ']' }
    }
    tabTable['DataGrip'] = {
        left = { mod = {'command', 'shift'}, key = '[' },
        right = { mod = {'command', 'shift'}, key = ']' }
    }
    tabTable['_else_'] = {
        left = { mod = {'control'}, key = 'pageup' },
        right = { mod = {'control'}, key = 'pagedown' }
    }

    local function tabMove(dir)
        return function()
            vimlike.close()
            local activeAppName = hs.application.frontmostApplication():name()
            local tab = tabTable[activeAppName] or tabTable['_else_']
            hs.eventtap.event.newKeyEvent(tab[dir]['mod'], tab[dir]['key'], true):post()
            hs.eventtap.event.newKeyEvent(tab[dir]['mod'], tab[dir]['key'], false):post()
            -- hs.eventtap.keyStroke(tab[dir]['mod'], tab[dir]['key'])
        end
    end

    vim_mode:bind({}, ',', tabMove('left'), vimlike.close, vimlike.close)
    vim_mode:bind({}, '.', tabMove('right'), vimlike.close, vimlike.close)
end

do  -- app manager
    local mode = app_mode

    local at = {}
    at['System Preferences'] = { mod = {}, key = ',' }
    at['Activity Monitor'] = { mod = {}, key = '/' }
    at['safari'] = { mod = {}, key = 'a' }
    at['Google Chrome'] = { mod = {}, key = 'c' }
    at['discord'] = { mod = {}, key = 'd' }
    at['Finder'] = { mod = {}, key = 'e' }
    at['Emacs'] = { mod = {'shift'}, key = 'e' }
    at['Firefox'] = { mod = {}, key = 'f' }
    at['DataGrip'] = { mod = {}, key = 'g' }
    at['IntelliJ IDEA'] = { mod = {}, key = 'i' }
    at['KakaoTalk'] = { mod = {}, key = 'k' }
    at['Line'] = { mod = {}, key = 'l' }
    at['NoSQLBooster for MongoDB'] = { mod = {}, key = 'm' }
    at['Notes'] = { mod = {}, key = 'n' }
    at['Notion'] = { mod = {'shift'}, key = 'n' }
    at['Microsoft OneNote'] = { mod = {}, key = 'o' }
    at['Preview'] = { mod = {}, key = 'p' }
    at['Messages'] = { mod = {}, key = 'm' }
    at['Sequel Pro'] = { mod = {}, key = 'q' }
    at['draw.io'] = { mod = {}, key = 'r' }
    at['Slack'] = { mod = {}, key = 's' }
    at['iTerm'] = { mod = {}, key = 'space' }
    at['Terminal'] = { mod = {'shift'}, key = 'space' }
    at['Telegram'] = { mod = {}, key = 't' }
    at['VimR'] = { mod = {}, key = 'v' }
    at['Visual Studio Code'] = { mod = {'shift'}, key = 'v' }
    at['Microsoft Excel'] = { mod = {}, key = 'x' }
    at['zoom.us'] = { mod = {}, key = 'z' }

    for app_name, v in pairs(at) do
        local mod = at[app_name]['mod']
        local key = at[app_name]['key']
        mode:bind(mod, key, app_man:toggle(app_name), function() mode:exit() end)
    end

    mode:bind({}, 'tab', hs.hints.windowHints)
    hs.hints.hintChars = {
        'q', 'w', 'e', 'r',
        'a', 's', 'd', 'f',
        'z', 'x', 'c', 'v',
        '1', '2', '3', '4',
        'j', 'k',
        'i', 'o',
        'm', ','
    }

    mvim = true
    mode:bind({'control'}, 'v', function()

    end)
end

function set_win_move(mode)
    mode:bind({}, '0', win_move.default)
    mode:bind({'shift'}, '0', win_move.move(1/6, 0, 4/6, 1))
    mode:bind({}, '1', win_move.left_bottom)
    mode:bind({}, '2', win_move.bottom)
    mode:bind({}, '3', win_move.right_bottom)
    mode:bind({}, '4', win_move.left)
    mode:bind({'shift'}, '4', win_move.move(0, 0, 2/3, 1))
    mode:bind({}, '5', win_move.full_screen)
    mode:bind({}, '6', win_move.right)
    mode:bind({'shift'}, '6', win_move.move(1/3, 0, 2/3, 1))
    mode:bind({}, '7', win_move.left_top)
    mode:bind({}, '8', win_move.top)
    mode:bind({}, '9', win_move.right_top)
    mode:bind({}, '-', win_move.prev_screen)
    mode:bind({}, '=', win_move.next_screen)
    -- mode:bind({}, 'left', win_move.move_relative(-10, 0), function() end, win_move.move_relative(-10, 0))
    -- mode:bind({}, 'right', win_move.move_relative(10, 0), function() end, win_move.move_relative(10, 0))
    -- mode:bind({}, 'up', win_move.move_relative(0, -10), function() end, win_move.move_relative(0, -10))
    -- mode:bind({}, 'down', win_move.move_relative(0, 10), function() end, win_move.move_relative(0, 10))
    mode:bind({}, 'z', function()
        local win = hs.window.focusedWindow()

        if win == nil then
            win = hs.window.frontmostWindow()
        end
        local screen = win:screen()
        local cell = hs.grid.get(win, screen)

        print(cell)

        hs.grid.set(win, cell, screen)
    end)
end

set_win_move(app_mode)
set_win_move(vim_mode)

-- spoon plugins
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = false

function plugInstall()
    local Install=spoon.SpoonInstall
    Install:updateRepo('default')

    Install:installSpoonFromRepo('Caffeine')

    hs.alert.show('plugin installed')
end


require('modules.Caffeine'):init(spoon)
require('modules.inputsource_aurora')
require('modules.touch')

hs.alert.show('loaded')

