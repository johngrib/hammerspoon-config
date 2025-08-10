
local function touch_e() -- touch + e
    local edgeTable = {}
    edgeTable['Slack'] = { x = -35, y = 55, click = false }
    edgeTable['Microsoft Excel'] = { x = -50, y = 170, click = false }
    edgeTable['Google Chrome'] = { x = -245, y = 60, click = false }
    edgeTable['_else_'] = { x = -30, y = 30, click = false }

    local activeAppName = hs.application.frontmostApplication():name()
    local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

    local screen = hs.window.focusedWindow():frame()
    hs.mouse.absolutePosition({ x = screen.x + screen.w + edgeMove['x'], y = screen.y + edgeMove['y'] })

    if edgeMove['click'] then
        hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
    end
end

local function touch_q()
    local edgeTable = {}
    edgeTable['Microsoft Excel'] = { x = 240, y = 100, click = true }
    edgeTable['_else_'] = { x = 0, y = 30, click = false }

    local activeAppName = hs.application.frontmostApplication():name()
    local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

    local screen = hs.window.focusedWindow():frame()
    hs.mouse.absolutePosition({ x = screen.x + edgeMove['x'], y = screen.y + edgeMove['y'] })

    if edgeMove['click'] then
        hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
    end
end

local function touch_w()
    local edgeTable = {}
    edgeTable['Microsoft Excel'] = { x = 60, y = 90, click = true }
    edgeTable['_else_'] = { x = -30, y = 30, click = false }

    local activeAppName = hs.application.frontmostApplication():name()
    local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

    local screen = hs.window.focusedWindow():frame()
    hs.mouse.absolutePosition({ x = screen.x + screen.w / 2 + edgeMove['x'], y = screen.y + edgeMove['y'] })

    if edgeMove['click'] then
        hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
    end
end

local function touch_a()
    local edgeTable = {}
    edgeTable['Google Chrome'] = { x = 30, y = 60, click = false }
    edgeTable['_else_'] = { x = -30, y = 30, click = false }

    local activeAppName = hs.application.frontmostApplication():name()
    local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

    local screen = hs.window.focusedWindow():frame()
    hs.mouse.absolutePosition({ x = screen.x + edgeMove['x'], y = screen.y + screen.h / 2 })

    if edgeMove['click'] then
        hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
    end
end

local function touch_s()
    local screen = hs.window.focusedWindow():frame()
    hs.mouse.absolutePosition(hs.geometry.rectMidPoint(screen))
end


local function touch_c()
    local edgeTable = {}
    edgeTable['DeepL'] = { x = -50, y = -100, click = true }
    edgeTable['_else_'] = { x = -30, y = -30, click = false }

    local activeAppName = hs.application.frontmostApplication():name()
    local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

    local screen = hs.window.focusedWindow():frame()
    hs.mouse.absolutePosition({ x = screen.x + screen.w + edgeMove['x'], y = screen.y + screen.h + edgeMove['y'] })

    if edgeMove['click'] then
        hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
    end
end

local function touch_z()
    local edgeTable = {}
    edgeTable['Slack'] = { x = 130, y = -30, click = false }
    edgeTable['_else_'] = { x = -30, y = -30, click = false }

    local activeAppName = hs.application.frontmostApplication():name()
    local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

    local screen = hs.window.focusedWindow():frame()
    hs.mouse.absolutePosition({ x = screen.x + edgeMove['x'], y = screen.y + screen.h + edgeMove['y'] })

    if edgeMove['click'] then
        hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
    end
end

-- 1. 모드와 타이머를 위한 변수 설정
local touch_mode_count = 0
local touchMode = hs.hotkey.modal.new()
local touchTimer = hs.timer.new(0.3, function()
    -- 타이머가 만료되면 (0.1초간 움직임 없으면) 모드 종료
    -- hs.alert.closeSpecific("touchModeActive", 0) -- 알림 즉시 닫기
    -- hs.alert.show("touch timeout")
    touchMode:exit()
    touch_mode_count = 0
end)

function touchMode:entered()
    -- hs.alert.show( "👆 Touch Mode")
end

function touchMode:exited()
    -- hs.alert.show("Mode Exited")
    touch_mode_count = 0
end

-- 3. 마우스(트랙패드) 움직임 감지를 위한 이벤트 탭 생성
mouseWatcher = hs.eventtap.new({hs.eventtap.event.types.mouseMoved}, function(event)
    -- 마우스 이벤트가 들어오면 타이머를 재시작 (모드 유지)
    touchTimer:start()

    -- 현재 'touchMode'가 아니라면, 모드로 진입
    if touch_mode_count == 0 then
        touch_mode_count = touch_mode_count + 1
        touchMode:enter()
    end

    -- 이 이벤트는 다른 앱으로 계속 전달되도록 false 반환
    return false
end)

-- 4. 이벤트 탭 시작
mouseWatcher:start()

touchMode:bind("", "q", touch_q)
touchMode:bind("", "w", touch_w)
touchMode:bind("", "e", touch_e)
touchMode:bind("", "a", touch_a)
touchMode:bind("", "s", touch_s)
touchMode:bind("", "c", touch_c)
touchMode:bind("", "z", touch_z)

