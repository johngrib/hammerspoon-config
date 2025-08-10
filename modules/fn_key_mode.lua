--[[
    참고: https://www.hammerspoon.org/Spoons/FnMate.html
--]]
local function catcher(event)
    if not event:getFlags()['fn'] then
        return false
    end
    if event:getFlags()['fn'] and event:getCharacters() == "s" then
        return true, { hs.alert.show("fn + s") }
    elseif event:getFlags()['fn'] and event:getCharacters() == "." then
        return true, { hs.alert.show("fn + .") }
    end
end
fn_tapper = hs.eventtap.new({hs.eventtap.event.types.keyDown}, catcher):start()

