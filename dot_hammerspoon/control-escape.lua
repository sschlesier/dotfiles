-- https://github.com/jasonrudolph/ControlEscape.spoon
-- Tap control alone → escape. Hold control + another key → normal control behavior.

local CANCEL_DELAY_SECONDS = 0.150
local sendEscape = false
local lastModifiers = {}

local controlKeyTimer = hs.timer.delayed.new(CANCEL_DELAY_SECONDS, function()
  sendEscape = false
end)

local keyDownTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function()
  sendEscape = false
  return false
end)

local flagsTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
  local newModifiers = event:getFlags()

  if lastModifiers['ctrl'] == newModifiers['ctrl'] then
    return false
  end

  if not lastModifiers['ctrl'] then
    lastModifiers = newModifiers
    sendEscape = true
    controlKeyTimer:start()
  else
    if sendEscape then
      hs.eventtap.keyStroke({}, 'escape', 1)
    end
    lastModifiers = newModifiers
    controlKeyTimer:stop()
  end
  return false
end)

flagsTap:start()
keyDownTap:start()
