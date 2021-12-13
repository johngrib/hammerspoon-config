local tabTable = {}

tabTable['Slack'] = {
  left = { mod = {'option'}, key = 'up' },
  right = { mod = {'option'}, key = 'down' }
}
tabTable['Safari'] = {
  left = { mod = {'control', 'shift'}, key = 'tab' },
  right = { mod = {'control'}, key = 'tab' }
}
tabTable['터미널'] = {
  left = { mod = {'control', 'shift'}, key = 'tab' },
  right = { mod = {'control'}, key = 'tab' }
}
tabTable['iTerm2'] = {
  left = { mod = {'shift', 'command'}, key = '[' },
  right = { mod = {'shift', 'command'}, key = ']' }
}
tabTable['IntelliJ IDEA'] = {
  left = { mod = {'command', 'shift'}, key = '[' },
  right = { mod = {'command', 'shift'}, key = ']' }
}
tabTable['Code'] = {
  left = { mod = {'command', 'shift'}, key = '[' },
  right = { mod = {'command', 'shift'}, key = ']' }
}
tabTable['DataGrip'] = {
  left = { mod = {'command', 'shift'}, key = '[' },
  right = { mod = {'command', 'shift'}, key = ']' }
}
tabTable['_else_'] = {
  left = { mod = {'control'}, key = 'pageup' },
  right = { mod = {'control'}, key = 'pagedown' }
}

local function tabMove(dir)
  return function()
      local activeAppName = hs.application.frontmostApplication():name()
      local tab = tabTable[activeAppName] or tabTable['_else_']
      hs.eventtap.event.newKeyEvent(tab[dir]['mod'], tab[dir]['key'], true):post()
      hs.eventtap.event.newKeyEvent(tab[dir]['mod'], tab[dir]['key'], false):post()
  end
end

hs.hotkey.bind({'command', 'shift'}, ',', tabMove('left'), nil, tabMove('left'))
hs.hotkey.bind({'command', 'shift'}, '.', tabMove('right'), nil, tabMove('right'))

