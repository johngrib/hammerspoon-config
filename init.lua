-- hammerspoon config

ENGLISH_INPUTS = {
    ["com.apple.keylayout.ABC"] = true,
    ["org.youknowone.inputmethod.Gureum.system"] = true
}
KOREAN_INPUTS = {
    ["org.youknowone.inputmethod.Gureum.han2"] = true,
    ["com.apple.inputmethod.Korean.2SetKorean"] = true
}

function getAvailableInput(inputs)
    for inputName, _ in pairs(inputs) do
        if hs.keycodes.currentSourceID(inputName) then
            return inputName
        end
    end
end

INPUT_ENGLISH = getAvailableInput(ENGLISH_INPUTS)
INPUT_KOREAN = getAvailableInput(KOREAN_INPUTS)


local win_move = require('modules.winmove')
local app_man = require('modules.appman')
local app_mode = hs.hotkey.modal.new()

do
    local config_path = package.searchpath('local_config', package.path)
    if config_path then
        require('local_config')
    end
end

f13_event_runner = require('modules.event_runner')
f17_event_runner = require('modules.event_runner')
f18_event_runner = require('modules.event_runner')

hs.window.animationDuration = 0

FLAG = {
    finally_esc = false,
    triggered = false,
    reservation = false,
    leader_key_pressed = false,
    time = 0,
    func = nil,
}

function app_toggle(name, secondName)
    if secondName == nil then
        -- FIXME: uuid 말고 대책을 마련하라
        secondName = '85ED2184-ABF5-4924-AE3F-B702622B858D'
    end
    return function()
        FLAG.finally_esc = false
        local activated = hs.application.frontmostApplication()
        local path = string.lower(activated:path())
        -- hs.alert.show(path)

        if string.match(path, string.lower(name) .. '%.app$') then
            activated:hide()
            return
        elseif string.match(path, string.lower(secondName) .. '%.app$') then
            activated:hide()
            return
        end

        if not hs.application.launchOrFocus(name) then
            hs.application.launchOrFocus(secondName)
        end

        local screen = hs.window.focusedWindow():frame()
        local pt = hs.geometry.rectMidPoint(screen)
        hs.mouse.absolutePosition(pt)
    end
end

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
tabTable['Ghostty'] = {
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
        FLAG.finally_esc = false
        local activeAppName = hs.application.frontmostApplication():name()
        local tab = tabTable[activeAppName] or tabTable['_else_']
        hs.eventtap.event.newKeyEvent(tab[dir]['mod'], tab[dir]['key'], true):post()
    end
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

function rapidKey(modifiers, key)
    modifiers = modifiers or {}
    return function()
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
        hs.timer.usleep(100)
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
    end
end

local f13_event_map = {
    -- hammerspoon 관리
    { key = 'r', mod = {'shift'}, func = hs.reload },
    -- app_toggle
    -- { key = 'n', mod = {}, func = app_toggle('Notion') },
    -- { key = 'm', mod = {}, func = app_toggle('Google Meet') },
    { key = 'd', mod = {}, func = app_toggle('dictionary') },
    -- { key = 'p', mod = {}, func = app_toggle('Postman') },
    { key = 'r', mod = {}, func = app_toggle('draw.io') },
    -- { key = 'p', mod = {}, func = app_toggle('Poe') },
    { key = 'h', mod = {}, func = rapidKey({}, 'left') },
    { key = 'j', mod = {}, func = rapidKey({}, 'down') },
    { key = 'k', mod = {}, func = rapidKey({}, 'up') },
    { key = 'l', mod = {}, func = rapidKey({}, 'right') },
    { key = ',', mod = {}, func = tabMove('left') },
    { key = '.', mod = {}, func = tabMove('right') },
}

local f17_event_map = {
    -- app_toggle
    { key = ',', mod = {}, func = app_toggle('System Preferences'), msg = 'System Preferences' },
    { key = '/', mod = {}, func = app_toggle('Activity Monitor') },
    { key = 'a', mod = {}, func = app_toggle('safari') },
    { key = 'c', mod = {}, func = app_toggle('Google Chrome') },
    { key = 'd', mod = {}, func = app_toggle('discord') },
    { key = 'e', mod = {}, func = app_toggle('Finder') },
    { key = 'f', mod = {}, func = app_toggle('Firefox') },
    { key = 'g', mod = {}, func = app_toggle('DataGrip', 'DBeaver') },
    { key = 'i', mod = {}, func = app_toggle('IntelliJ IDEA Community Edition', 'IntelliJ IDEA') },
    { key = 'k', mod = {}, func = app_toggle('KakaoTalk') },
    { key = 'l', mod = {}, func = app_toggle('DeepL') },
    { key = 'm', mod = {}, func = app_toggle('Microsoft Edge') },
    { key = 'n', mod = {}, func = app_toggle('Notes') },
    -- { key = 'o', mod = {}, func = app_toggle('Microsoft OneNote') },
    { key = 'p', mod = {}, func = app_toggle('Preview') },
    { key = 'r', mod = {}, func = app_toggle('Reminders') },
    { key = 's', mod = {}, func = app_toggle('Slack') },
    -- { key = 't', mod = {}, func = app_toggle('Telegram') },
    { key = 'v', mod = {}, func = app_toggle('VimR') },
    -- { key = 'v', mod = {'shift'}, func = app_toggle('Visual Studio Code') },
    -- { key = 'x', mod = {}, func = app_toggle('Microsoft Excel') },
    -- { key = 'space', mod = {}, func = app_toggle('iTerm') },
    { key = 'space', mod = {}, func = app_toggle('Terminal') },
    -- { key = 'space', mod = {}, func = app_toggle('Alacritty') },
    -- { key = 'space', mod = {}, func = app_toggle('WezTerm') },
    { key = 'space', mod = {'shift'}, func = app_toggle('Ghostty') },
    { key = 'tab', mod = {}, func = hs.hints.windowHints },
    { key = 'tab', mod = {'shift'}, func = hs.window._timed_allWindows },
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
}

do
    f13_event_runner:init('f13', f13_event_map)
    f17_event_runner:init('f17', f17_event_map)
end

local f18_event_map = {
    { key = 's', mod = {}, func = win_move.prev_screen },
}
do
    f18_event_runner:init('f18', f18_event_map)
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
require('modules.english_apps')
-- require('modules.touch')
require('modules.fn_key_mode')

-- chrome 브라우저 전용 설정
require('modules.app_chrome')

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

hs.alert.show('loaded')

local escWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    -- 모든 키 코드 확인하는 방법: hs.inspect(hs.keycodes.map)
    -- print("KeyCode:", event:getKeyCode(), "Key:", hs.keycodes.map[event:getKeyCode()])
    -- ESC 키 코드: 53
    if event:getKeyCode() == 53 then
        hs.keycodes.currentSourceID(INPUT_ENGLISH)
        hs.alert.show('escape', 0.5)
    end
    return false -- 이벤트를 계속 전달 (ESC 동작은 유지됨)
end)

escWatcher:start()
