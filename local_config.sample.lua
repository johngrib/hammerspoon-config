
do
    -- https://github.com/hetima/hammerspoon-foundation_remapping
    local FRemap = require('modules.foundation_remapping')
    local remapper = FRemap.new()

    remapper:remap('rcmd', 'f15')
    remapper:remap('ralt', 'f17')
    remapper:register()
end

hs.alert.show('local_config loaded')

