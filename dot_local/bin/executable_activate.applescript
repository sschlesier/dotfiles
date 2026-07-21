#! /usr/bin/osascript

on run argv
  if (count of argv) is 0 then return "no args"
  set bundleId to item 1 of argv

  -- Check if it's already running via System Events, before touching AppleScript's
  -- `activate` verb. `activate` internally polls Launch Services in a loop to confirm
  -- the frontmost-process change, and each poll pays a slow permission check -- that's
  -- what causes multi-second stalls. Skipping it for already-running apps (the common
  -- case) avoids that entirely; we only fall back to it to launch a not-yet-running app.
  set isRunning to false
  tell application "System Events"
    set isRunning to (exists (first process whose bundle identifier is bundleId))
  end tell

  if not isRunning then
    -- Launch/activate the app by bundle id
    tell application id bundleId
      activate
    end tell
  end if

  -- Now, via System Events, bring a non-empty-titled window forward
  tell application "System Events"
    set appProc to first process whose bundle identifier is bundleId
    repeat with w in windows of appProc
      try
        set t to name of w
      on error
        set t to ""
      end try
      if t is not "" then
        set frontmost of appProc to true
        set value of attribute "AXMain" of w to true
        exit repeat
      end if
    end repeat
  end tell

  -- “echo” the bundle id for the next Alfred step
  return bundleId
end run
