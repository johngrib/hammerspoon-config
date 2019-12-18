local boxes = {}
local inputEnglish = "com.apple.keylayout.ABC"
local box_height = 23
local box_alpha = 0.5

-- 입력소스 변경 이벤트에 이벤트 리스너를 달아준다
hs.keycodes.inputSourceChanged(function()
    local input_source = hs.keycodes.currentSourceID()
    show_status_bar(not (input_source == inputEnglish))
end)

function show_aurora(scr)
    local box = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
    draw_rectangle(box, scr, 0, scr:fullFrame().w, hs.drawing.color.osx_green)
    table.insert(boxes, box)
end

function show_status_bar(stat)
    if stat then
        enable_show()
    else
        disable_show()
    end
end

function enable_show()
    show_status_bar(false)
    reset_boxes()
    hs.fnutils.each(hs.screen.allScreens(), function(scr)
        show_aurora(scr)
    end)
end

function disable_show()
    hs.fnutils.each(boxes, function(box)
        if not (box == nil) then
            box:delete()
        end
    end)
    reset_boxes()
end

function reset_boxes()
    boxes = {}
end

function draw_rectangle(target_draw, screen, offset, width, fill_color)
  local screeng                  = screen:fullFrame()
  local screen_frame_height      = screen:frame().y
  local screen_full_frame_height = screeng.y
  local height_delta             = screen_frame_height - screen_full_frame_height
  local height                   = box_height

  target_draw:setSize(hs.geometry.rect(screeng.x + offset, screen_full_frame_height, width, height))
  target_draw:setTopLeft(hs.geometry.point(screeng.x + offset, screen_full_frame_height))
  target_draw:setFillColor(fill_color)
  target_draw:setFill(true)
  target_draw:setAlpha(box_alpha)
  target_draw:setLevel(hs.drawing.windowLevels.overlay)
  target_draw:setStroke(false)
  target_draw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
  target_draw:show()
end
