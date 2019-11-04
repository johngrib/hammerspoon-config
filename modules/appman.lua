local obj = {}
local app_mode = hs.hotkey.modal.new()

function obj:toggle(name, secondName)
    if secondName == nil then
        -- FIXME: uuid 말고 대책을 마련하라
        secondName = '85ED2184-ABF5-4924-AE3F-B702622B858D'
    end
    return function()

        local activated = hs.application.frontmostApplication()
        local path = string.lower(activated:path())

        if string.match(path, string.lower(name) .. '%.app$') or string.match(path, string.lower(secondName) .. '%.app$') then
            return activated:hide()
        end

        if not hs.application.launchOrFocus(name) then
            hs.application.launchOrFocus(secondName)
        end

        local screen = hs.window.focusedWindow():frame()
        local pt = hs.geometry.rectMidPoint(screen)
        hs.mouse.setAbsolutePosition(pt)
        app_mode.triggered = true
    end
end

local function focusScreen(screen)
  local windows = hs.fnutils.filter(
      hs.window.orderedWindows(),
      hs.fnutils.partial(isInScreen, screen))
  local windowToFocus = #windows > 0 and windows[1] or hs.window.desktop()
  windowToFocus:focus()

  -- Move mouse to center of screen
  local center = hs.geometry.rectMidPoint(screen:fullFrame())
  hs.mouse.setAbsolutePosition(center)
end

function obj.focusPreviousScreen()
    focusScreen(hs.window.focusedWindow():screen():previous())
end

function obj.focusNextScreen()
    focusScreen(hs.window.focusedWindow():screen():next())
end

function obj:init(mod, key)

    --app_mode:bind({}, 'left', function() hS.WINDOW.FOCUSEDwINDOW():FOCUSwINDOWWest() end)
    --app_mode:bind({}, 'down', function() hs.window.focusedWindow():focusWindowSouth() end)
    --app_mode:bind({}, 'up', function() hs.window.focusedWindow():focusWindowNorth() end)
    --app_mode:bind({}, 'right', function() hs.window.focusedWindow():focusWindowEast() end)

    return self
end

return obj
