local obj = {}

function obj:init(spoon)
    hs.loadSpoon('Caffeine')

    spoon.Caffeine:bindHotkeys({
        toggle = {{'control'}, 'f19'},
    })

    spoon.Caffeine:start()
    spoon.Caffeine:setState(true)
end

return obj
