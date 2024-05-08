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

-- function send_event(callback_func, msg)
--     -- hs.alert.show('send event')
--     flag.func = callback_func
--     flag.triggered = false
--     flag.reservation = true
--     flag.msg = msg
-- end

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

        -- hs.timer.doWhile(
        --     function() return flag.leader_key_pressed end,
        --     function()
        --         local old_flag = flag

        --         if os.time() - old_flag.time >= 5 then
        --             -- 너무 오래됐다면 타임아웃
        --             hs.alert.show('app manager timeout')
        --             -- flag를 초기화한다.
        --             flag = {
        --                 triggered = false,
        --                 reservation = false,
        --                 leader_key_pressed = false,	-- 무한루프를 중단한다
        --                 time = 0,
        --                 func = nil,
        --             }
        --             event_runner_icon:setTitle('')
        --             mode:exit()
        --             return
        --         end

        --         if old_flag.func == nil then
        --             -- 아직 지정된 함수가 없다면 다음 루프로 진행하며 입력을 기다린다
        --             return
        --         else
        --             -- 지정된 함수가 있다면 flag 를 초기화하고, 함수를 실행한다
        --             flag = {
        --                 triggered = true,
        --                 reservation = false,
        --                 leader_key_pressed = old_flag.leader_key_pressed,
        --                 time = os.time(),
        --                 func = nil,
        --             }
        --             -- 함수를 나중에 실행하는 이유는 함수 실행 시간이 오래 걸릴 수 있기 때문이다.
        --             old_flag.func()
        --         end

        --         -- hs.alert.show('msg')
        --         if flag['msg'] then
        --             hs.alert.show(flag['msg'])
        --         end
        --     end,
        --     0.001)
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
                hs.eventtap.keyStroke({}, 'right')
                hs.keycodes.currentSourceID(inputEnglish)
            end
            hs.alert.show('escape', 0.5)
            hs.eventtap.keyStroke({}, 'escape')
        end
    end

    hs.hotkey.bind({}, key, on_mode, off_mode)

    return obj
end

return obj
