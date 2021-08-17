-- hammerspoon config

-- require('luarocks.loader')
-- require('modules.mouse'):init('f16')
local inputEnglish = "com.apple.keylayout.ABC"
local inputKorean = "org.youknowone.inputmethod.Gureum.han2"

local vim_mode = hs.hotkey.modal.new()
local app_mode = hs.hotkey.modal.new()
local vimlike = require('modules.vim'):init(vim_mode)

hs.hotkey.bind({}, 'f17', function() app_mode:enter() end, function() app_mode:exit() end)

hs.hotkey.bind({}, 'f19', function()
    local screen = hs.window.focusedWindow():screen()
    local pt = hs.geometry.rectMidPoint(screen:fullFrame())
    hs.mouse.setAbsolutePosition(pt)
end)

local maccy = function()
    -- maccy 는 단축키 조합에 f1 ~ f20 이 들어가면 인식을 못한다.
    hs.eventtap.keyStroke({'command', 'shift', 'option', 'control'}, 'c')
end

hs.hotkey.bind({}, 'f14', maccy) -- for maccy

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
            local activeAppName = hs.application.frontmostApplication():name()
            local tab = tabTable[activeAppName] or tabTable['_else_']
            hs.eventtap.keyStroke(tab[dir]['mod'], tab[dir]['key'])
        end
    end

    vim_mode:bind({}, ',', tabMove('left'), vimlike.close, tabMove('left'))
    vim_mode:bind({}, '.', tabMove('right'), vimlike.close, tabMove('right'))
end

do  -- app manager
    local app_man = require('modules.appman')
    local mode = app_mode

    -- mode:bind({'shift'}, 'space', app_man:toggle('Alacritty'))
    -- mode:bind({}, 'b', app_man:toggle('Robo 3T'))
    -- mode:bind({}, 'e', app_man:toggle('SpringToolSuite4'))
    -- mode:bind({}, 'i', app_man:toggle('PhpStorm'))
    -- mode:bind({}, 'r', app_man:toggle('Reminders'))
    -- mode:bind({}, 'space', app_man:toggle('Alacritty'))
    -- mode:bind({}, 'space', app_man:toggle('iTerm'))
    -- mode:bind({}, 'v', app_man:toggle('MacVim'))

    mode:bind({}, ',', app_man:toggle('System Preferences'))
    mode:bind({}, 'a', app_man:toggle('safari'))
    mode:bind({}, 'b', app_man:toggle('DBeaver'))
    mode:bind({}, 'c', app_man:toggle('Google Chrome'))
    mode:bind({}, 'd', app_man:toggle('dictionary'))
    mode:bind({'option'}, 'd', app_man:toggle('Discord'))
    mode:bind({}, 'e', app_man:toggle('Finder'))
    mode:bind({}, 'f', app_man:toggle('Firefox'))
    mode:bind({}, 'g', app_man:toggle('DataGrip'))
    mode:bind({}, 'i', app_man:toggle('IntelliJ IDEA'))
    mode:bind({}, 'k', app_man:toggle('KakaoTalk'))
    mode:bind({}, 'l', app_man:toggle('Line'))
    mode:bind({}, 'm', app_man:toggle('NoSQLBooster for MongoDB'))
    mode:bind({}, 'n', app_man:toggle('Notes'))
    mode:bind({}, 'o', app_man:toggle('Microsoft OneNote'))
    mode:bind({}, 'p', app_man:toggle('Preview'))
    mode:bind({}, 'q', app_man:toggle('Sequel Pro'))
    -- mode:bind({}, 'r', app_man:toggle('Trello'))
    mode:bind({}, 'r', app_man:toggle('draw.io'))
    mode:bind({}, 's', app_man:toggle('Slack'))
    mode:bind({}, 'space', app_man:toggle('Terminal'))
    -- mode:bind({}, 'space', app_man:toggle('iTerm'))
    mode:bind({}, 't', app_man:toggle('Telegram'))
    mode:bind({}, 'v', app_man:toggle('VimR'))
    mode:bind({'option'}, 'v', app_man:toggle('Visual Studio Code'))
    mode:bind({}, 'w', app_man:toggle('Microsoft Word'))
    mode:bind({}, 'x', app_man:toggle('Microsoft Excel'))
    mode:bind({}, 'z', app_man:toggle('zoom.us'))


    -- mode:bind({'shift'}, 'tab', app_man.focusPreviousScreen)
    -- mode:bind({}, 'tab', app_man.focusNextScreen)

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

do  -- winmove
    local win_move = require('modules.winmove')
    local mode = app_mode

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
end

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

