
--[[
  Chrome 브라우저에서 Command + L 키를 눌렀을 때
  화면에 알림을 표시하고, 원래의 주소창 포커스 기능도 그대로 동작하게 합니다.
--]]

-- 키보드 이벤트를 감시할 이벤트 탭(EventTap) 생성
local commandL_sideEffect = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
  -- 현재 활성화된 애플리케이션이 Google Chrome인지 확인합니다.
  local app = hs.application.frontmostApplication()
  if app and app:bundleID() == "com.google.Chrome" then

    -- 눌린 키가 정확히 Command + L 조합인지 확인합니다.
    -- :containExactly({'cmd'})는 다른 조합키(예: Shift) 없이 Command 키만 눌렸는지 검사합니다.
    if event:getKeyCode() == hs.keycodes.map.l and event:getFlags():containExactly({'cmd'}) then
      -- hs.alert.show("✨ 주소창으로 이동! ✨", 0.5) -- 0.5초 동안 메시지를 보여줍니다.
      hs.keycodes.currentSourceID(INPUT_ENGLISH)

    end
  end

  -- 항상 false를 반환하여 키 입력이 macOS 시스템으로 계속 전달되도록 합니다.
  -- 만약 true를 반환하면, 키 입력이 여기서 멈추고 Chrome까지 전달되지 않습니다.
  return false
end)

-- 이벤트 탭 감시 시작
commandL_sideEffect:start()
