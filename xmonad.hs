--
-- xmonad example config file for xmonad-0.9
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
-- NOTE: Those updating from earlier xmonad versions, who use
-- EwmhDesktops, safeSpawn, WindowGo, or the simple-status-bar
-- setup functions (dzen, xmobar) probably need to change
-- xmonad.hs, please see the notes below, or the following
-- link for more details:
--
-- http://www.haskell.org/haskellwiki/Xmonad/Notable_changes_since_0.8
--
--
-- TODO:
--  - Check whether xcompmgr is present and set window border width to 1 if it
--    is not.
--  - keys to switch to specific windows (i.e. alt+left to switch to the window
--    on the left, alt+right to switch to the window on the right - although
--    probably nicer to use alt+j/k.
--  - some default layouts on VM workspaces, pidgin workspace, firefox workspace
--  - a better layout for pidgin workspace
--  - more controlled layout switching; i.e. <M-S-numpad1> through <M-S-numpadn> for layouts
--  - SmartBorders
--  - A submenu alt+space, [1|2|3|4|..] to select layout
--  - ephemeral workspace names - pop up a teensy menu to name a workspace, then
--    pop up a menu to select one by name (dmenu?)
--  - ephemeral window names - pop up a teensy menu to name a window, then pop up
--    a menu to select one by name (dmenu?) (or by number?)
--  - searchable window names: create a list of all windows currently open, and
--    relevant properties (_NET_WM_NAME, WM_NAME, WM_CLASS, WM_WINDOW_ROLE etc.) then
--    provide them to dmenu and switch to the workspace they're on and focus them
--  - toggling of window titles and borders
--  - Check this out:
--    http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-DecorationMadness.html
--  - disable focus-follows-mouse on accordion layouts (focus on click?)
--  - accordion layout where all windows simply disappear into a title bar when
--    they're not focused? (Is this approximatley simpletabbed?)

import XMonad
import Data.Monoid
import Data.List
import System.Exit
import XMonad.Layout.NoBorders
import XMonad.Actions.Warp
import XMonad.Actions.WindowGo
import XMonad.Actions.CycleRecentWS
import XMonad.Actions.Search
import XMonad.Actions.Navigation2D
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.FadeWindows
import XMonad.Layout.Grid
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Accordion
import XMonad.Layout.Spiral

import qualified XMonad.Prompt                as P
import qualified XMonad.Actions.Submap        as SM
import qualified XMonad.Actions.Search        as S
import qualified XMonad.StackSet              as W
import qualified Data.Map                     as M
import qualified XMonad.Util.WindowProperties as WP

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "urxvt"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask

-- NOTE: from 0.9.1 on numlock mask is set automatically. The numlockMask
-- setting should be removed from configs.
--
-- You can safely remove this even on earlier xmonad versions unless you
-- need to set it to something other than the default mod2Mask, (e.g. OSX).
--
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
-- myNumlockMask   = mod2Mask -- deprecated in xmonad-0.9.1
------------------------------------------------------------


-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["`","1","2","3","4","5","6","7","8","9","0","-","=","BS","INS","HOME","PGUP"] --,"NUM_LOCK","/","*"]

-- Border colors for unfocused and focused windows, respectively.
--
-- myNormalBorderColor  = "#dddddd"
-- myFocusedBorderColor = "#ff0000"
myNormalBorderColor  = "#002b36" -- Solarized dark background colour
myFocusedBorderColor = "#657b83" -- Solarized dark foreground colour

-- Search engines
ddg = searchEngine "DuckDuckGo" "https://duckduckgo.com/?q="
-- Search engine map
searchEngineMap method = M.fromList $
    [ ((0, xK_g), method S.google)
    , ((0, xK_w), method S.wikipedia)
    , ((0, xK_m), method S.maps)
    , ((0, xK_d), method ddg)
    ]

searchAndGoTo = do
    SM.submap $ searchEngineMap $ S.promptSearch P.defaultXPConfig
    runOrRaiseNext "firefox" (stringProperty "WM_WINDOW_ROLE" =? "browser")

displayDateTwoScreens = do
    spawn "date | dzen2 -fg \"#ffffff\" -bg \"#000000\" -p 2 -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -xs 1"
    spawn "date | dzen2 -fg \"#ffffff\" -bg \"#000000\" -p 2 -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -xs 2"

-- Check whether a query passes. If it does, do nothing. If it does not, run
-- "spawn spawncmd"
checkAndSpawn :: XMonad.Query Bool -> String -> X ()
checkAndSpawn query spawncmd =
    ifWindows query (\w -> return ()) (spawn spawncmd)

-- Start stuff
startStuff = composeAll
    [ checkAndSpawn (className =? "Firefox") "firefox"
    , checkAndSpawn (className =? "Spotify") "spotify"
    , checkAndSpawn (className =? "chromium") "chromium"
    , checkAndSpawn (className =? "Pidgin") "pidgin"
    , checkAndSpawn (className =? "win7vm") "virt-viewer -c qemu:///system -w -f win7 --class win7vm"
    , checkAndSpawn (className =? "urxvt-iotop") "urxvt -name \"urxvt-iotop\" -e sudo iotop"
    , checkAndSpawn (className =? "urxvt-htop") "urxvt -name \"urxvt-htop\" -e htop"
    ]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- search
    , ((modm,               xK_s     ), searchAndGoTo)

    -- suspend
    , ((modm .|. shiftMask, xK_s     ), spawn "systemctl suspend")

    -- lock screen
    , ((modm .|. shiftMask, xK_l     ), spawn "xscreensaver-command --lock")

    -- launch firefox
    , ((modm,               xK_f     ), runOrRaiseNext "firefox" (className =? "Firefox"))

    -- cycle through windows in recently-used order
    -- , ((modm,               xK_Tab   ), cycleRecentWS [xK_Alt_L] xK_Tab xK_Tab)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- display date
    , ((modm .|. shiftMask, xK_t     ), displayDateTwoScreens)

    -- move pointer
    -- , ((modm .|. shiftMask, xK_b     ), banish UpperLeft)

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Open some stuff
    , ((modm .|. shiftMask, xK_b     ), startStuff)

    -- Move focus to the next window
    -- This has been commented out because
    --  a) it's not used
    --  b) it's convenient for windows vms to be able to use alt+tab, because
    --     they're primitive and cant use xmonad
--    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Turn volume up 10%
    , ((modm,               xK_KP_Add ), spawn "pactl set-sink-volume $(pactl list short | grep RUNNING | cut -f1) +10%")

    -- Previous track
    , ((modm,               xK_KP_Left ), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")

    -- Play/pause
    , ((modm,               xK_KP_Begin ),
        (ifWindows
            (className =? "Spotify")
            (\w -> spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
            (spawn "spotify")))

    -- Next track
    , ((modm,               xK_KP_Right ), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")

    -- Turn volume down 10%
    , ((modm,               xK_KP_Subtract ), spawn "pactl set-sink-volume $(pactl list short | grep RUNNING | cut -f1) -10%")

    -- Toggle mute
    , ((modm,               xK_KP_Insert ), spawn "pactl set-sink-mute 1 toggle")

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Move window focus left or right
    , ((modm,               xK_h     ), windowGo L False)
    , ((modm,               xK_l     ), windowGo R False)

    -- Shrink the master area
    -- , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    -- , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_grave, xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_minus, xK_equal, xK_BackSpace, xK_Insert, xK_Home, xK_Page_Up] --, xK_Num_Lock, xK_KP_Divide, xK_KP_Multiply]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = noBorders tiled ||| Mirror (noBorders tiled) ||| noBorders Full ||| GridRatio (16/10)
  ||| noFrillsDeco shrinkText defaultTheme (GridRatio (16/10))
  ||| noFrillsDeco shrinkText defaultTheme Accordion ||| spiral golden
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    golden  = toRational (2/(1+sqrt(5)::Double))

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"                      --> doFloat
    , className =? "Gimp"                         --> doFloat
    , className =? "Vmplayer"                     --> doFloat
    , resource  =? "desktop_window"               --> doIgnore
    , resource  =? "kdesktop"                     --> doIgnore
    , className =? "Firefox"                      --> doShift "`"
    , className =? "Spotify"                      --> doShift "HOME"
    , className =? "Pidgin"                       --> doShift "INS"
    , className =? "chromium"                     --> doShift "="
    , className =? "win7vm"                       --> doShift "PGUP"
    , className =? "urxvt-iotop"                  --> doShift "PGUP"
    , className =? "urxvt-htop"                   --> doShift "PGUP"
    -- , fmap (isPrefixOf "Virt") className          --> doShift "BS" -- Works
    -- , fmap (isPrefixOf "win7") (stringProperty "WM_NAME") --> doShift "BS"
      ]

    -- runOrRaiseNext "firefox" (stringProperty "WM_WINDOW_ROLE" =? "browser")
------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
-- myEventHook = fadeWindowsEventHook
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
myLogHook = fadeInactiveLogHook fadeAmount where fadeAmount = 0.92
-- myLogHook = fadeWindowsLogHook $ composeAll [isUnfocused --> transparency 0.2
--                                             ,                transparency 0.1
--                                             ]

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
myStartupHook = mempty

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        -- numlockMask deprecated in 0.9.1
        -- numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }