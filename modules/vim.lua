local obj = {}

local vim_icon = hs.menubar.new()
local inputEnglish = "com.apple.keylayout.ABC"

local cfg = {
    key_interval = 100,
    icon = { vim = "𝑽", novim = "" },
}

local mode = {
    on        = false,
    triggered = false,
}

local mouse_center = function()
    local screen = hs.window.focusedWindow():frame()
    local pt = hs.geometry.rectMidPoint(screen)
    hs.mouse.setAbsolutePosition(pt)
end

function setDefaultArrows(mode)
    hs.fnutils.each({
        { mod={} , key='h' , func=rapidKey({} , 'left')  , repetition=true } ,
        { mod={} , key='j' , func=rapidKey({} , 'down')  , repetition=true } ,
        { mod={} , key='k' , func=rapidKey({} , 'up')    , repetition=true } ,
        { mod={} , key='l' , func=rapidKey({} , 'right') , repetition=true } ,
        { mod={} , key='z' , func=mouse_center, repetition=false } ,

    }, function(v)
        if v.repetition then
            mode:bind(v.mod, v.key, v.func, vim_end, v.func)
        else
            mode:bind(v.mod, v.key, v.func, vim_end)
        end
    end)
end

function obj:init(mode)

    local function vim_end()
        mode.triggered = true
    end

    self.close = vim_end

    vim_icon:setClickCallback(setVimDisplay)

    setDefaultArrows(mode)

    self.on = function()
        mode:enter()
        setVimDisplay(true)
        mode.triggered = false
        mode.on = true
    end

    self.off = function()
        setVimDisplay()
        mode:exit()

        local input_source = hs.keycodes.currentSourceID()

        if not mode.triggered then
            if not (input_source == inputEnglish) then
                hs.eventtap.keyStroke({}, 'right')
                hs.keycodes.currentSourceID(inputEnglish)
                -- hs.eventtap.keyStroke({}, 'escape')
            end
            hs.eventtap.keyStroke({}, 'escape')
        end

        mode.triggered = true
        mode.on = false
    end

    return self
end

function isInScreen(screen, win)
  return win:screen() == screen
end

function setVimDisplay(state)
    if state then
        vim_icon:setTitle(cfg.icon.vim)
    else
        vim_icon:setTitle(cfg.icon.novim)
    end
end

function rapidKey(modifiers, key)
    modifiers = modifiers or {}
    return function()
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
        hs.timer.usleep(cfg.key_interval)
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
    end
end

function inputKey(modifiers, key)
    modifiers = modifiers or {}
    return function()
        hs.eventtap.keyStroke(modifiers, key)
    end
end

return obj
