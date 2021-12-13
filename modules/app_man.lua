local function toggle(name)
    secondName = '85ED2184-ABF5-4924-AE3F-B702622B858D'
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
        local pt = hs.geometry.rectMidPoit(screen)
        hs.mouse.setAbsolutePosition(pt)
    end
end

hs.hotkey.bind({'option'}, 'w', toggle('draw.io'))
hs.hotkey.bind({'option'}, 'e', toggle('Finder'))
hs.hotkey.bind({'option'}, 't', toggle('Todoist'))
hs.hotkey.bind({'option'}, 'i', toggle('IntelliJ IDEA'))
hs.hotkey.bind({'option'}, 'o', toggle('Microsoft Outlook'))

hs.hotkey.bind({'option'}, 's', toggle('Slack'))
hs.hotkey.bind({'option'}, 'd', toggle('DataGrip'))
hs.hotkey.bind({'option'}, 'g', toggle('GitKraken'))

hs.hotkey.bind({'option'}, 'c', toggle('Google Chrome'))
hs.hotkey.bind({'option'}, 'v', toggle('Visual Studio Code'))
hs.hotkey.bind({'option'}, 'n', toggle('Notion'))
hs.hotkey.bind({'option'}, 'm', toggle('Melon'))
hs.hotkey.bind({'option'}, ',', toggle('System Preferences'))
hs.hotkey.bind({'option'}, '.', toggle('KakaoTalk'))
hs.hotkey.bind({'option'}, '/', toggle('Activity Monitor'))

hs.hotkey.bind({'option'}, 'space', toggle('iTerm'))

