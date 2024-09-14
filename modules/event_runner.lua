local obj = {}

local event_runner_icon = hs.menubar.new()
local inputEnglish = "com.apple.keylayout.ABC"

local flag = {
    -- func = function() end
    triggered = false,
    reservation = false,
    leader_key_pressed = false,
    time = 0,
    func = nil,
}

local function_table = {}

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

function obj:init(key, func_table, is_press_escape)
    local mode = hs.hotkey.modal.new()

    self.mode = mode

    function_table = func_table

    for i, v in pairs(function_table) do
        -- hs.alert.show(i)
        local mod = v['mod']
        local lkey = v['key']
        -- mode:bind(mod, lkey, function() send_event(v['func'], v['msg']) end)
        mode:bind(mod, lkey, v['func'])
    end

    local on_mode = function()
        -- hs.alert.show('on mode')
        flag = {
            triggered = false,
            leader_key_pressed = true,
            time = os.time(),
            func = nil
        }
        mode:enter()
        event_runner_icon:setTitle('A')
    end

    local off_mode = function()
        local trig = flag.triggered
        mode:exit()

        flag = {
            triggered = false,
            leader_key_pressed = false,
            func = nil,
            time = 0
        }
        event_runner_icon:setTitle('')

        if not trig then
            local input_source = hs.keycodes.currentSourceID()
            if not (input_source == inputEnglish) then
                if is_press_escape then
                    hs.eventtap.keyStroke({}, 'right')
                end
                hs.keycodes.currentSourceID(inputEnglish)
            end
            if is_press_escape then
                hs.alert.show('escape', 0.5)
                hs.eventtap.keyStroke({}, 'escape')
            end
        end
    end

    hs.hotkey.bind({}, key, on_mode, off_mode)

    return obj
end

return obj
