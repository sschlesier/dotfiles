-- Key inspector: toggle with Cmd+Shift+K
local hud = nil
local tap = nil

local function stopInspector()
    if tap then tap:stop(); tap = nil end
    if hud then hud:delete(); hud = nil end
end

local function startInspector()
    hud = hs.canvas.new({ x = 20, y = 40, w = 440, h = 80 })
    hud:appendElements(
        { type = "rectangle", action = "fill",
          fillColor = { alpha = 0.88, red = 0.08, green = 0.08, blue = 0.08 },
          roundedRectRadii = { xRadius = 8, yRadius = 8 } },
        { type = "text", text = "Press any key...",
          textColor = { white = 1 }, textSize = 15,
          frame = { x = 12, y = 8, w = 416, h = 64 } }
    )
    hud:show()

    tap = hs.eventtap.new(
        { hs.eventtap.event.types.keyDown, hs.eventtap.event.types.flagsChanged },
        function(e)
            local keyCode = e:getKeyCode()
            local flags   = e:getFlags()   -- returns a table like {cmd=true, shift=true, ...}
            local mods = {}
            for mod, active in pairs(flags) do
                if active then mods[#mods + 1] = mod end
            end
            table.sort(mods)
            local charStr = hs.keycodes.map[keyCode] or "?"
            local modStr  = #mods > 0 and table.concat(mods, " + ") or "none"
            local newText = ("Key: %s  (code %d)\nMods: %s"):format(charStr, keyCode, modStr)
            -- replace the element outright — most reliable canvas update method
            hud[2] = { type = "text", text = newText,
                       textColor = { white = 1 }, textSize = 15,
                       frame = { x = 12, y = 8, w = 416, h = 64 } }
            return false
        end
    )
    tap:start()
end

local active = false
hs.hotkey.bind({ "cmd", "shift" }, "k", function()
    active = not active
    if active then startInspector() else stopInspector() end
    hs.alert(active and "Key Inspector ON" or "Key Inspector OFF")
end)
