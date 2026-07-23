-- Focus (launching if needed) an app by name, triggered from the shell:
--   open "hammerspoon://focus?app=Cursor"
-- Used by the `ide` zsh function to reliably raise CLI-launched apps, since
-- macOS Tahoe no longer auto-focuses windows opened via CLI/IPC.
hs.urlevent.bind("focus", function(eventName, params)
  local app = params.app
  if not app then return end
  hs.application.launchOrFocus(app)
end)
