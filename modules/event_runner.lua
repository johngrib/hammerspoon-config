local obj = {}

local vim_icon = hs.menubar.new()
local inputEnglish = "com.apple.keylayout.ABC"

local flag = {
    -- func = function() end
    triggered = false,
    reservation = false,
    leader_key_pressed = false,
}

local function_table = {}

function send_event(callback_func, msg)
    -- hs.alert.show('send event')
    flag.func = callback_func
    flag.triggered = false
    flag.reservation = true
    flag.msg = msg
end

function invoke_event()
    local func = flag['func']
    if func then
        func()
    end
end

function toggle(name, secondName)
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

function obj:init(key, func_table)
    local mode = hs.hotkey.modal.new()
    function_table = func_table

    for i, v in pairs(function_table) do
        -- hs.alert.show(i)
        local mod = v['mod']
        local lkey = v['key']
        mode:bind(mod, lkey, function() send_event(v['func'], v['msg']) end)
    end

    local on_mode = function()
        -- hs.alert.show('on mode')
        flag = {
            triggered = false,
            leader_key_pressed = true,
            func = nil
        }
        mode:enter()

        hs.timer.doWhile(
            function() return flag.leader_key_pressed end,
            function()
                local func = flag['func']
                if not func then
                    return
                end
                func()
                -- hs.alert.show('msg')
                if flag['msg'] then
                    hs.alert.show(flag['msg'])
                end
                flag.triggered = true
                flag.func = false
                flag.msg = nil
            end,
            0.001)
    end

    local off_mode = function()
        -- hs.alert.show('off mode')
        if not flag.triggered then
            local input_source = hs.keycodes.currentSourceID()
            if not (input_source == inputEnglish) then
                hs.eventtap.keyStroke({}, 'right')
                hs.keycodes.currentSourceID(inputEnglish)
            end
            hs.alert.show('escape')
            hs.eventtap.keyStroke({}, 'escape')
        end

        flag = {
            triggered = false,
            leader_key_pressed = false,
            func = nil
        }
        mode:exit()
    end

    hs.hotkey.bind({}, key, on_mode, off_mode)

    return
end

return obj
