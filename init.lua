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

-- hs.hotkey.bind({}, 'f17', function() app_mode:enter() end, function() app_mode:exit() end)

local maccy = function()
    -- maccy 는 단축키 조합에 f1 ~ f20 이 들어가면 인식을 못한다.
    hs.eventtap.keyStroke({'command', 'shift', 'option', 'control'}, 'c')
end

hs.hotkey.bind({'shift'}, 'f14', maccy) -- for maccy

function app_toggle(name, secondName)
    if secondName == nil then
        -- FIXME: uuid 말고 대책을 마련하라
        secondName = '85ED2184-ABF5-4924-AE3F-B702622B858D'
    end
    return function()
        local activated = hs.application.frontmostApplication()
        local path = string.lower(activated:path())

        if string.match(path, string.lower(name) .. '%.app$') or string.match(path, string.lower(secondName) .. '%.app$') then
            activated:hide()
            return
        end

        if not hs.application.launchOrFocus(name) then
            hs.application.launchOrFocus(secondName)
        end

        local screen = hs.window.focusedWindow():frame()
        local pt = hs.geometry.rectMidPoint(screen)
        hs.mouse.setAbsolutePosition(pt)
    end
end


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

hs.hints.hintChars = {
    'q', 'w', 'e', 'r',
    'a', 's', 'd', 'f',
    'z', 'x', 'c', 'v',
    '1', '2', '3', '4',
    'j', 'k',
    'i', 'o',
    'm', ','
}

local event_runner = require('modules.event_runner'):init('f17', {
    -- app_toggle
    { key = ',', mod = {}, func = app_toggle('System Preferences'), msg = 'System Preferences' },
    { key = '/', mod = {}, func = app_toggle('Activity Monitor') },
    { key = 'a', mod = {}, func = app_toggle('safari') },
    { key = 'c', mod = {}, func = app_toggle('Google Chrome') },
    { key = 'd', mod = {}, func = app_toggle('discord') },
    { key = 'e', mod = {}, func = app_toggle('Finder') },
    { key = 'f', mod = {}, func = app_toggle('Firefox') },
    { key = 'g', mod = {}, func = app_toggle('DataGrip') },
    { key = 'i', mod = {}, func = app_toggle('IntelliJ IDEA') },
    { key = 'k', mod = {}, func = app_toggle('KakaoTalk') },
    { key = 'l', mod = {}, func = app_toggle('Line') },
    { key = 'm', mod = {}, func = app_toggle('NoSQLBooster for MongoDB') },
    { key = 'n', mod = {}, func = app_toggle('Notes') },
    { key = 'o', mod = {}, func = app_toggle('Microsoft OneNote') },
    { key = 'p', mod = {}, func = app_toggle('Preview') },
    { key = 'q', mod = {}, func = app_toggle('Sequel Pro') },
    { key = 'r', mod = {}, func = app_toggle('draw.io') },
    { key = 's', mod = {}, func = app_toggle('Slack') },
    { key = 't', mod = {}, func = app_toggle('Telegram') },
    { key = 'v', mod = {}, func = app_toggle('VimR') },
    { key = 'v', mod = {'shift'}, func = app_toggle('Visual Studio Code') },
    { key = 'x', mod = {}, func = app_toggle('Microsoft Excel') },
    { key = 'tab', mod = {}, func = hs.hints.windowHints },
    -- win_move
    { key = '0', mod = {}, func = win_move.default },
    { key = '0', mod = {'shift'}, func = win_move.move(1/6, 0, 4/6, 1) },
    { key = '1', mod = {}, func = win_move.left_bottom },
    { key = '2', mod = {}, func = win_move.bottom },
    { key = '3', mod = {}, func = win_move.right_bottom },
    { key = '4', mod = {}, func = win_move.left },
    { key = '4', mod = {'shift'}, func = win_move.move(0, 0, 2/3, 1) },
    { key = '5', mod = {}, func = win_move.full_screen },
    { key = '6', mod = {}, func = win_move.right },
    { key = '6', mod = {'shift'}, func = win_move.move(1/3, 0, 2/3, 1) },
    { key = '7', mod = {}, func = win_move.left_top },
    { key = '8', mod = {}, func = win_move.top },
    { key = '9', mod = {}, func = win_move.right_top },
    -- win_move to next screen
    { key = '-', mod = {}, func = win_move.prev_screen },
    { key = '=', mod = {}, func = win_move.next_screen },
    { key = '`', mod = {}, func = win_move.prev_screen },
})

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

