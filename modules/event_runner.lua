local obj = {}

local event_runner_icon = hs.menubar.new()

local function_table = {}

function obj:init(key, func_table)
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
        mode:enter()
        event_runner_icon:setTitle('A')
        FLAG.finally_esc = true
    end

    local off_mode = function()
        mode:exit()

        event_runner_icon:setTitle('')

        if FLAG.finally_esc then
            -- local input_source = hs.keycodes.currentSourceID()
            -- if not (input_source == INPUT_ENGLISH) then
            --     hs.eventtap.keyStroke({}, 'right')
            --     hs.keycodes.currentSourceID(INPUT_ENGLISH)
            -- end
            hs.alert.show('escape', 0.5)
            hs.eventtap.keyStroke({}, 'escape')
        end
        FLAG.finally_esc = false
    end

    hs.hotkey.bind({}, key, on_mode, off_mode)

    return obj
end

return obj
