local function moveToFraction(win, x, y, w, h)
  local screen = win:screen()
  local f = win:frame()
  local sf = screen:frame()

  f.x = sf.x + sf.w * x
  f.y = sf.y + sf.h * y
  f.w = sf.w * w
  f.h = sf.h * h
  win:setFrame(f)
end

-- Left Half (⌃⌥←)
hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  moveToFraction(win, 0, 0, 0.5, 1)
end)

-- Right Half (⌃⌥→)
hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  moveToFraction(win, 0.5, 0, 0.5, 1)
end)

-- Next Display (⌃⌥⌘→)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Right", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToScreen(win:screen():next(), false, true)
end)

-- Previous Display (⌃⌥⌘←)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Left", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToScreen(win:screen():previous(), false, true)
end)

-- Last Third (⌃⌥R)
hs.hotkey.bind({"ctrl", "alt"}, "R", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  moveToFraction(win, 2/3, 0, 1/3, 1)
end)

-- First Two Thirds (⌃⌥E)
hs.hotkey.bind({"ctrl", "alt"}, "E", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  moveToFraction(win, 0, 0, 2/3, 1)
end)

-- Maximize (⌃⌥Return)
hs.hotkey.bind({"ctrl", "alt"}, "Return", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:maximize()
end)
