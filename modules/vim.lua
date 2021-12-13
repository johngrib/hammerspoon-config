local input_english = "com.apple.keylayout.ABC"

local function rapidKey(key, mod)
    mod = mod or {}
    return function()
        hs.eventtap.event.newKeyEvent(mod, string.lower(key), true):post()
        hs.eventtap.event.newKeyEvent(mod, string.lower(key), false):post()
    end
end

local function escapeVim()
    local input_source = hs.keycodes.currentSourceID()
    if not (input_source == input_english) then
        rapidKey('right')()
        hs.keycodes.currentSourceID(input_english)
    end
    rapidKey('escape')()
end

local mouseCenter = function()
    local screen = hs.window.focusedWindow():frame()
    local pt = hs.geometry.rectMidPoint(screen)
    hs.mouse.setAbsolutePosition(pt)
end

escapeBind = hs.hotkey.bind({}, 'escape', function()
    escapeBind:disable()
    escapeVim()
    escapeBind:enable()
end)
hs.hotkey.bind({'option'}, 'h', rapidKey('left'), nil, rapidKey('left'))
hs.hotkey.bind({'option'}, 'j', rapidKey('down'), nil, rapidKey('down'))
hs.hotkey.bind({'option'}, 'k', rapidKey('up'), nil, rapidKey('up'))
hs.hotkey.bind({'option'}, 'l', rapidKey('right'), nil, rapidKey('right'))
hs.hotkey.bind({'option'}, 'z', mouseCenter)

