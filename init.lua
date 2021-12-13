require('modules.caffeine')
require('modules.inputsource_aurora')
require('modules.tab')
require('modules.app_man')
require('modules.vim')
require('modules.win_move')

local function showActiveAppName()
    local activeAppName = hs.application.frontmostApplication():name()
    hs.alert.show(activeAppName)
end

function plugInstall()
    local install = spoon.SpoonInstall
    install:updateRepo('default')
    install:installSpoonFromRepo('Caffeine')
    print('HS plugin (Caffeine) installed')
end

function clear()
    hs.console.clearConsole()
end

hs.hints.hintChars = {
    'q', 'w', 'e', 'r',
    'a', 's', 'd', 'g',
    'z', 'x', 'c', 'v',
    'u', 'i', 'o', 'p',
    'j', 'k', 'l', ';',
}

-- OPTION
-- Q W E R T y u I O p [ ]
-- A S D f G H J K L : '
-- Z x C V b N M < > ?
--        SPACE

hs.hotkey.bind({'option'}, 'q', hs.caffeinate.systemSleep)
hs.hotkey.bind({'option'}, 'r', hs.reload)
hs.hotkey.bind({'option'}, 'a', showActiveAppName)
hs.hotkey.bind({'option'}, ';', hs.hints.windowHints)

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = false

plugInstall()
hs.alert.show('HS loaded')

