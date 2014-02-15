--- 
-- Multicolor Awesome WM config 2.0 
--

--- Dependencies --------------------------------------------------------------
gears           = require "gears"
awful           = require "awful"
awful.rules     = require "awful.rules"
awful.autofocus = require "awful.autofocus"
wibox           = require "wibox"
beautiful       = require "beautiful"
naughty         = require "naughty"
drop            = require "scratchdrop"
lain            = require "lain"

--- Helper functions ----------------------------------------------------------

-- Spawn a process once and only once. Will not try to spawn cmd if it is already running
run_once = (cmd) ->
  findme = cmd
  firstspace = cmd\find " "
  
  if firstspace
    findme = cmd\sub(0, firstspace-1)

  awful.util.spawn_with_shell "pgrep -u $USER -x #{findme} > /dev/null || (#{cmd})"

--- Variable definitions ------------------------------------------------------

-- User-defined
export browser    = "chromium"
export browser2   = "firefox"
export gui_editor = "subl"
export graphics   = "gimp"

-- Common
export modkey     = "Mod4"
export altkey     = "Mod1"
export terminal   = "urxvtc"
export editor     = os.getenv("EDITOR") or "vim"
export editor_cmd = "#{terminal} -e #{editor}"

-- Session-controls
session = {
  logout: "logout"
  shutdown: "poweroff"
  reboot: "reboot"
  lock: "xscreensaver-command --lock"
}

-- Desktop tags (organized as {name,layout} tuple)
desktops = {
  { "1", awful.layout.suit.max }
  { "2", lain.layout.uselesstile }
  { "3", lain.layout.uselesstile }
  { "4", lain.layout.uselesstile }
  { "5", awful.layout.suit.floating }
  { "6", awful.layout.suit.max }
}

--- Handle startup errors -----------------------------------------------------

if awesome.startup_errors
  naughty.notify {
    preset: naughty.config.presets.critical
    title: "Oops, there were errors during startup!"
    text: awesome.startup_errors
  }

do
  in_error = false

  awesome.connect_signal "debug::error", (err) ->
    return if in_error

    in_error = true
    naughty.notify {
      preset: naughty.config.presets.critical
      title: "Oops, an error happened!"
      text: err
    }
    in_error = false

--- Begin Awesome Startup Procedure -------------------------------------------

-- Applications
run_once "unagi &"
run_once "urxvtd"
run_once "thunar --daemon &"
run_once "xbindkeys"
run_once "redshift-scheduler &"
run_once "battery_monitor"
run_once "xscreensaver -nosplash &"

awful.util.spawn_with_shell "conky -c /home/cheine/.conky/rc.datetime"
awful.util.spawn_with_shell "conky -c /home/cheine/.conky/rc.weather"

-- Set Localization
os.setlocale os.getenv "LANG"

-- Initialize beautiful
beautiful.init "#{awful.util.getdir 'config'}/themes/multicolor/theme.lua"

-- Generate desktop tags and layouts
SCREEN_COUNT = screen.count!

tags = names: {}, layout: {}

for s,{name,layout} in ipairs(desktops)
  table.insert tags.names, name
  table.insert tags.layout, layout

for s=1,SCREEN_COUNT
  table.insert tags, awful.tag(tags.names, s, tags.layout)

-- Set wallpaper(s)
if beautiful.wallpaper
  for s=1, SCREEN_COUNT
    gears.wallpaper.maximized beautiful.wallpaper, s, true

-- Freedesktop Menu (Look at this evil module not returning a table... bastards)
require "freedesktop/freedesktop"

--- Widget configuration and setup --------------------------------------------

import markup from lain.util

-- Textclock
clockicon = wibox.widget.imagebox beautiful.widget_clock
mytextclock = awful.widget.textclock "#{markup '#7788af', '%A %d %B '}#{markup '#343639', '>'}#{markup '#de5e1e', ' %H:%M '}"

-- Calendar
lain.widgets.calendar\attach mytextclock, { font_size: 10 }

-- Weather
weathericon = wibox.widget.imagebox beautiful.widget_weather
yawn = lain.widgets.yawn 123456, {
    settings: ->
      widget\set_markup markup "#eca4c4", "#{forecast\lower!} @ #{units}°C "
  }

-- / fs
fsicon = wibox.widget.imagebox beautiful.widget_fs
fswidget = lain.widgets.fs {
    settings: ->
      widget\set_markup markup "#80d9d8", "#{used}% "
  }

-- CPU
cpuicon = wibox.widget.imagebox beautiful.widget_cpu
cpuwidget = lain.widgets.cpu {
    settings: ->
      widget\set_markup markup "#e33a6e", "#{cpu_now.usage}% "
  }

-- Coretemp
tempicon = wibox.widget.imagebox beautiful.widget_temp
tempwidget = lain.widgets.temp {
    settings: ->
      widget\set_markup markup "#f1af5f", "#{coretemp_now}°C "
  }

-- Battery
baticon   = wibox.widget.imagebox beautiful.widget_batt
batwidget = lain.widgets.contrib.tpbat
  settings: ->
    bat_now.perc = if bat_now.perc == "N/A"
        "AC "
      else
        bat_now.perc ..= "% "
    widget\set_text bat_now.perc

-- ALSA volume
volicon = wibox.widget.imagebox beautiful.widget_vol
volumewidget = lain.widgets.alsa {
    settings: ->
      volume_now.level ..= "M" if volume_now.status == "off"
      widget\set_markup markup "#7493d2", "#{volume_now.level}% "
  }

-- Net 
netdownicon = wibox.widget.imagebox beautiful.widget_netdown
--netdownicon.align = "middle"
netdowninfo = wibox.widget.textbox!

netupicon = wibox.widget.imagebox(beautiful.widget_netup)
--netupicon.align = "middle"
netupinfo = lain.widgets.net {
    settings: ->
      widget\set_markup markup "#e54c62", "#{net_now.sent} "
      netdowninfo\set_markup markup "#87af5f", "#{net_now.received} "
  }

-- MEM
memicon = wibox.widget.imagebox beautiful.widget_mem
memwidget = lain.widgets.mem {
    settings: ->
      widget\set_markup markup "#e0da37", "#{mem_now.used}M "
  }

-- MPD
mpdicon = wibox.widget.imagebox!
mpdwidget = lain.widgets.mpd {
    settings: ->
      tmpl = "%s [%s] - %s\n%s"
      {:artist, :album, :date, :title} = mpd_now
      mpd_notification_preset = text: tmpl\format artist, album, date, title

      artist, title = "artist", "title"
      switch mpd_now.state
        when "play"
          artist = "#{mpd_now.artist} > "
          title  = "#{mpd_now.title} "
          mpdicon\set_image beautiful.widget_note_on
        when "pause"
          artist = "mpd "
          title  = "paused "
        else
          artist = ""
          title  = ""
          mpdicon\set_image nil

      widget\set_markup "#{markup '#e54c62', artist}#{markup '#b2b2b2', title}"
  }

-- Spacer
spacer = wibox.widget.textbox " "

--- Setup Layout --------------------------------------------------------------

-- Create a wibox for each screen and add it
my = {
  wibox: {}
  bottomwibox: {}
  promptbox: {}
  layoutbox: {}
  taglist: {}
  tasklist: {}
}

-- Taglist
my.taglist.buttons = awful.util.table.join {
    awful.button {        }, 1, awful.tag.viewonly
    awful.button { modkey }, 1, awful.client.movetotag
    awful.button {        }, 3, awful.tag.viewtoggle
    awful.button { modkey }, 3, awful.client.toggletag
    awful.button {        }, 4, (t) -> awful.tag.viewnext awful.tag.getscreen t
    awful.button {        }, 5, (t) -> awful.tag.viewnext awful.tag.getscreen t
  }

-- Tasklist
_t = {
  minimize: (c) ->
    if c == client.focus
      c.minimized = true
    else
      -- Without this, the following :isvisible() makes no sense
      c.minimized = false

      if not c\isvisible!
        awful.tag.viewonly c\tags![1]

      -- This will also un-minimize the client, if needed
      client.focus = c
      c\raise!

  hide: ->
    if instance
      instance\hide!
      instance = nil
    else
      instance = awful.menu.clients width: 250

  focus: ->
    awful.client.focus.byidx 1
    client.focus\raise! if client.focus
}

my.tasklist.buttons = awful.util.table.join {
    awful.button { }, 1, _t.minimize
    awful.button { }, 3, _t.hide
    awful.button { }, 4, _t.hide
    awful.button { }, 5, _t.focus
  }

for s=1, SCREEN_COUNT
  -- Create a promptbox for each screen
  my.promptbox[s] = awful.widget.prompt!

  -- We need one layout per screen
  _l_up = ->
    awful.layout.inc layouts, 1

  _l_down = ->
    awful.layout.inc layouts, -1

  my.layoutbox[s] = with awful.widget.layoutbox s
    \buttons awful.util.table.join {
        awful.button { }, 1, _l_up
        awful.button { }, 3, _l_down
        awful.button { }, 4, _l_up
        awful.button { }, 5, _l_down
      }

  -- Create a tasklist widget
  my.tasklist[s] = awful.widget.tasklist s,
    awful.widget.tasklist.filter.currenttags,
    my.tasklist.buttons

  -- Create the upper wibox
  my.wibox[s] = awful.wibox position: "top", screen: s, height: 20

  -- Widgets that are aligned to the upper-left
  left_layout = with wibox.layout.fixed.horizontal!
    \add my.taglist[s]
    \add my.promptbox[s]
    \add mpdicon
    \add mpdwidget

  -- Widgets that are aligned to the upper-right
  right_layout = with wibox.layout.fixed.horizontal!
    \add wibox.widget.systray! if s == 1
    \add netdownicon
    \add netdowninfo
    \add netupicon
    \add netupinfo
    \add volicon
    \add volumewidget
    \add memicon
    \add memwidget
    \add cpuicon
    \add fsicon
    \add weathericon
    \add yawn.widget
    \add tempicon
    \add tempwidget
    \add baticon
    \add batwidget
    \add clockicon
    \add mytextclock

  -- Now bring it all together (with the tasklist in the middle)
  layout = with wibox.layout.align.horizontal!
    \set_left left_layout
    \set_right right_layout

  my.wibox[s]\set_widget layout

  -- Create the bottom wibox
  my.bottomwibox[s] = awful.wibox position: "bottom", screen: s, border_width: 0, height: 20
  --my.bottomwibox[s].visible = false

  -- Widgets that are aligned to the bottom-left
  bottom_left_layout = with wibox.layout.fixed.horizontal!
    \add my.layoutbox[s]

  -- Widgets that are aligned to the bottom-right
  bottom_right_layout = with wibox.layout.fixed.horizontal!
    \add my.layoutbox[s]

  -- Now bring it all together (with the tasklist in the middle)
  bottom_layout = with wibox.layout.align.horizontal!
    \set_left bottom_left_layout
    \set_middle my.tasklist[s]
    \set_right bottom_right_layout

  my.bottomwibox[s]\set_widget bottom_layout

--- Mouse Bindings ------------------------------------------------------------

root.buttons awful.util.table.join {
    awful.button { }, 3, -> my.mainmenu\toggle!
    awful.button { }, 4, awful.tag.viewnext
    awful.button { }, 5, awful.tag.viewprev
  }

--- Key Bindings --------------------------------------------------------------

class Bindings
  -- Globalkey helpers
  screenshot = ->
    os.execute "scrot ~/screenshots/%Y-%m-%d-%T-screenshot.png"
    
  lock_screen = ->
    os.execute "xscreensaver-command -lock"

  id_focus = (i) ->
    awful.client.focus.byidx i
    client.focus\raise! if client.focus

  next_tag = ->
    id_focus 1

  prev_tag = ->
    id_focus -1

  focus = (d) ->
    awful.client.focus.bydirection d
    client.focus\raise! if client.focus

  toggle_wibox = ->
    my.wibox[mouse.screen].visible = not my.wibox[mouse.screen].visible
    my.bottomwibox[mouse.screen].visible = not my.bottomwibox[mouse.screen].visible

  goto_previous_tag = ->
    awful.client.focus.history.previous!
    client.focus\raise! if client.focus

  volume_ctl = (c) ->
    awful.util.spawn "amixer -q set Master #{c}"
    volumewidget.update!

  mpd_ctl = (c) ->
    awful.util.spawn_with_shell "mpc #{c} || ncmpcpp #{c} || ncmpc #{c} || pms #{c}"
    mpdwidget.update!

  run_lua_code = ->
    awful.prompt.run {prompt: "Run Lua code: "},
      my.promptbox[mouse.screen].widget,
      awful.util.eval, nil,
      "#{awful.util.getdir "cache"}/history_eval"

  create_key = (combo, fn) ->
    last = #combo
    last_key = combo[last]
    first_keys = [ k for i,k in ipairs(combo) when i < last-1 ]
    awful.key first_keys, last_key, fn

  global_keys: setmetatable {
    -- Screenshot
    [{ modkey, "p" }]: screenshot

    -- Tag browsing
    [{ modkey, "Left"   }]: awful.tag.viewprev
    [{ modkey, "Right"  }]: awful.tag.viewnext
    [{ modkey, "Escape" }]: awful.tag.history.restore

    -- Non-empty tag browsing
    [{ altkey, "Left"  }]: -> lain.util.tag_view_nonempty -1
    [{ altkey, "Right" }]: -> lain.util.tag_view_nonempty 1

    -- Default client focus
    [{ altkey, "k" }]: next_tag
    [{ altkey, "j" }]: prev_tag

    -- Directional client focus
    [{ modkey, "j" }]: -> focus "down"
    [{ modkey, "k" }]: -> focus "up"
    [{ modkey, "h" }]: -> focus "left"
    [{ modkey, "l" }]: -> focus "right"

    -- Session Lock
    [{ modkey, "L" }]: lock_screen

    -- Show menu
    [{ modkey, "w" }]: -> my.mainmenu\show keygrabber: true

    -- Show/Hide Wibox
    [{ modkey, "b" }]: toggle_wibox

    -- Layout manipulation
    [{ modkey, "Shift",   "j"     }]: -> awful.client.swap.byidx 1
    [{ modkey, "Shift",   "k"     }]: -> awful.client.swap.byidx -1
    [{ modkey, "Control", "j"     }]: -> awful.screen.focus_relative 1
    [{ modkey, "Control", "k"     }]: -> awful.screen.focus_relative -1
    [{ modkey, "u"                }]: awful.client.urgent.jumpto
    [{ modkey, "Tab"              }]: goto_previous_tag
    [{ altkey, "Shift",   "l"     }]: -> awful.tag.incmwfact 0.05
    [{ altkey, "Shift",   "h"     }]: -> awful.tag.incmwfact -0.05
    [{ modkey, "Shift",   "l"     }]: -> awful.tag.incmaster -1
    [{ modkey, "Shift",   "h"     }]: -> awful.tag.incmaster 1
    [{ modkey, "Control", "l"     }]: -> awful.tag.incncol -1
    [{ modkey, "Control", "l"     }]: -> awful.tag.incncol -1
    [{ modkey, "space"            }]: -> awful.layout.inc layouts, 1
    [{ modkey, "Shift",   "space" }]: -> awful.layout.inc layouts, -1
    [{ modkey, "Control", "n"     }]: awful.client.restore

    -- Standard Program
    [{ modkey, "Return"       }]: -> awful.util.spawn terminal
    [{ modkey, "Control", "r" }]: awesome.restart
    [{ modkey, "Shift",   "q" }]: awesome.quit

    -- Dropdown (Doom) Terminal
    [{ modkey, "z" }]: -> drop terminal
    
    -- Widgets Popups
    [{ altkey, "c" }]: -> lain.widgets.calendar\show 7
    [{ altkey, "h" }]: -> fswidget.show 7
    [{ altkey, "w" }]: -> yawn.show 7

    -- ALSA Volume Control
    [{ altkey, "Up"      }]: -> volume_ctl "1%+"
    [{ altkey, "Down"    }]: -> volume_ctl "1%-"
    [{ altkey, "m"       }]: -> volume_ctl "playback toggle"
    [{ altkey, "Control" }]: -> volume_ctl "playback 100%"

    -- MPD Control
    [{ altkey, "Control", "Up"    }]: -> mpd_ctl "toggle"
    [{ altkey, "Control", "Down"  }]: -> mpd_ctl "stop"
    [{ altkey, "Control", "Left"  }]: -> mpd_ctl "prev"
    [{ altkey, "Control", "Right" }]: -> mpd_ctl "next"

    -- Copy to Clipboard
    [{ modkey, "c" }]: -> os.execute "xsel -p -o | xsel -i -b"

    -- Prompt
    [{ modkey, "r" }]: -> my.promptbox[mouse.screen]\run!
    [{ modkey, "x" }]: run_lua_code
  }, {
    __call: =>
      bound = {}
      for combo,fn in pairs @
        table.insert bound, create_key(combo, fn)
      awful.util.table.join unpack bound
  }

  -- Clientkey Helpers
  toggle_maximized = (c) ->
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical

  client_keys: setmetatable {
    [{ modkey, "f"                 }]: (c) -> c.fullscreen = not c.fullscreen
    [{ modkey, "q"                 }]: (c) -> c\kill!
    [{ modkey, "Control", "space"  }]: awful.client.floating.toggle
    [{ modkey, "Control", "Return" }]: (c) -> c\swap awful.client.getmaster!
    [{ modkey, "o"                 }]: awful.client.movetoscreen
    [{ modkey, "t"                 }]: (c) -> c.ontop = not c.ontop
    [{ modkey, "n"                 }]: (c) -> c.minimized = true
    [{ modkey, "m"                 }]: toggle_maximized
  }, {
    __call: =>
      bound = {}
      for combo,fn in pairs @
        table.insert bound, create_key(combo, fn)
      awful.util.table.join unpack bound
  }

  bind_numberkeys_to_tags: =>
    for i=1,9
      -- View tag
      @global_keys[{ modkey, "##{i+9}" }] = ->
        {:screen} = mouse
        tag = awful.tag.gettags(screen)[i]
        awful.tag.viewonly(tag) if tag

      -- View toggle tag
      @global_keys[{ modkey, "##{i+9}" }] = ->
        {:screen} = mouse
        tag = awful.tag.gettags(screen)[i]
        awful.tag.viewtoggle(tag) if tag

      -- Move to tag
      @global_keys[{ modkey, "Shift", "##{i+9}" }] = ->
        tag = awful.tag.gettags(client.focus.screen)[i]
        awful.client.movetotag(tag) if client.focus and tag

      -- Toggle tag
      @global_keys[{ modkey, "Control", "Shift", "##{i+9}" }] = ->
        tag = awful.tag.gettags(client.focus.screen)[i]
        awful.client.toggletag(tag) if client.focus and tag

  -- Clientbuttons Helpers
  focus_client = (c) ->
    client.focus = with c
      \raise!

  create_button = (combo, fn) ->
    last = #combo
    last_button = combo[last]
    first_buttons = [ b for i,b in ipairs(combo) when i < last ]
    awful.button first_buttons, last_button, fn

  client_buttons: setmetatable {
    [{ 1         }]: focus_client
    [{ modkey, 1 }]: awful.mouse.client.move
    [{ modkey, 3 }]: awful.mouse.client.resize
  }, {
    __call: =>
      bound = {}
      for combo,fn in pairs @
        table.insert bound, create_button(combo, fn)
      awful.util.table.join unpack bound
  }

-- 'Bindings' is basically a Singleton through how moonscript does classes without a new()
bindings = Bindings!

my.global_keys = bindings.global_keys!
my.client_keys = bindings.client_keys!
my.client_buttons = bindings.client_buttons!

root.keys my.global_keys

--- Rules ---------------------------------------------------------------------

awful.rules.rules = {
  {
    rule: {}
    properties: {
      border_width:     beautiful.border_width
      border_color:     beautiful.border_normal
      focus:            awful.client.focus.filter
      keys:             my.client_keys
      buttons:          my.client_buttons
      size_hints_honor: false
    }
  },
  {
    rule: class: "URxvt"
    properties: opacity: 0.99
  },
  {
    rule: class: "MPlayer"
    properties: floating: true
  }
}

--- Signals -------------------------------------------------------------------

cient.connect_signal "manage",
  (c, startup) ->
    -- Enable sloppy focus
    c\connect_signal "mouse::enter", (c) ->
      if awful.layout.get(c.screen) != awful.layout.suit.magnifier and awful.client.focus.filter c
        client.focus c

    if not startup and not c.size_hints.user_position and not c.size_hints.program_position
      with awful.placement
        .no_overlap c
        .no_offscreen c

client.connect_signal "focus",
  (c) ->
    is_max = c.maximized_horizontal == true and c.maximized_vertical == true
    {:border_width, :border_normal, :border_focus} = beautiful
    with c
      .border_width = if is_max then 0 else border_width
      .border_color = if is_max then border_normal else border_focus

client.connect_signal "unfocus",
  (c) ->
    c.border_color = beautiful.border_normal

--- Arrange Signal Handler ----------------------------------------------------

for s=1, SCREEN_COUNT
  screen[s]\connect_signal "arrange",
    ->
      clients = awful.client.visible s
      layout  = awful.layout.getname awful.layout.get s

      -- Fine-grained borders and float control
      if #clients > 0
        for _,c in pairs clients
          -- Floated items always have borders
          if awful.client.floating.get(c) or layout == "floating"
            c.border_width = beautiful.border_width

          -- No borders with only one visible client
          elseif #clients == 1 or layout == "max"
            clients[1].border_width = 0
            awful.client.moveresize 0, 0, 2, 2, clients[1]
          else
            c.border_width = beautiful.border_width

