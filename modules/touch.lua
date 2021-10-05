
hs.urlevent.bind("mouse-move-center", function(eventName, params)
    local screen = hs.window.focusedWindow():frame()
    hs.mouse.absolutePosition(hs.geometry.rectMidPoint(screen))
end)

do -- touch + e
    local edgeTable = {}
    edgeTable['Slack'] = { x = -35, y = 55, click = false }
    edgeTable['Microsoft Excel'] = { x = -50, y = 170, click = false }
    edgeTable['Google Chrome'] = { x = -245, y = 60, click = false }
    edgeTable['_else_'] = { x = -30, y = 30, click = false }

    hs.urlevent.bind("mouse-move-e", function(eventName, params)
        local activeAppName = hs.application.frontmostApplication():name()
        local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

        local screen = hs.window.focusedWindow():frame()
        hs.mouse.absolutePosition({ x = screen.x + screen.w + edgeMove['x'], y = screen.y + edgeMove['y'] })

        if edgeMove['click'] then
            hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
        end
    end)
end

do -- touch + q
    local edgeTable = {}
    edgeTable['Microsoft Excel'] = { x = 240, y = 100, click = true }
    edgeTable['_else_'] = { x = 0, y = 30, click = false }

    hs.urlevent.bind("mouse-move-q", function(eventName, params)
        local activeAppName = hs.application.frontmostApplication():name()
        local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

        local screen = hs.window.focusedWindow():frame()
        hs.mouse.absolutePosition({ x = screen.x + edgeMove['x'], y = screen.y + edgeMove['y'] })

        if edgeMove['click'] then
            hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
        end
    end)
end

do -- touch + w
    local edgeTable = {}
    edgeTable['Microsoft Excel'] = { x = 60, y = 90, click = true }
    edgeTable['_else_'] = { x = -30, y = 30, click = false }

    hs.urlevent.bind("mouse-move-w", function(eventName, params)
        local activeAppName = hs.application.frontmostApplication():name()
        local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

        local screen = hs.window.focusedWindow():frame()
        hs.mouse.absolutePosition({ x = screen.x + screen.w / 2 + edgeMove['x'], y = screen.y + edgeMove['y'] })

        if edgeMove['click'] then
            hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
        end
    end)
end

do -- touch + c
    local edgeTable = {}
    edgeTable['_else_'] = { x = -30, y = -30, click = false }

    hs.urlevent.bind("mouse-move-c", function(eventName, params)
        local activeAppName = hs.application.frontmostApplication():name()
        local edgeMove = edgeTable[activeAppName] or edgeTable['_else_']

        local screen = hs.window.focusedWindow():frame()
        hs.mouse.absolutePosition({ x = screen.x + screen.w + edgeMove['x'], y = screen.y + screen.h + edgeMove['y'] })

        if edgeMove['click'] then
            hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
        end
    end)
end
