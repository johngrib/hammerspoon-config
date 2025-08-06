-- 아래에 정의한 앱으로 전환되면 INPUT SOURCE 를 영어로 변환한다
local appsToForceEnglish = {
    ["iTerm2"] = true,
    ["Terminal"] = true,
    ["WezTerm"] = true,
    ["Alacritty"] = true,
    ["VimR"] = true,
    ["Code"] = true,
    ["IntelliJ IDEA"] = true,
    ["DataGrip"] = true,
    ["PhpStorm"] = true
}

local function applicationWatcher(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated and appsToForceEnglish[appName] then
        hs.keycodes.currentSourceID(INPUT_ENGLISH)
    end
end

local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()