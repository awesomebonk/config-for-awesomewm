local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local math, string, os = math, string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                   				= {}
theme.dir                                       				= os.getenv("HOME") .. "/.config/awesome/themes/browm"
theme.wallpaper                          				= theme.dir .. "/kyoko-sakura-po.jpg"
theme.font                                            		= "Input Mono Compresses 11"
theme.taglist_font                       				= "Iosevka Slab Medium 14"
theme.fg_normal                        				= "#FEFEFE" 
theme.fg_focus                            				= "#000000" 
theme.fg_urgent                          	 			= "#b74822"
theme.bg_normal                        				= "#C4B181" 
theme.bg_focus                           				= "#D05407#D03507"
theme.bg_urgent                           				= "#3F3F3F"
theme.taglist_fg_focus               				= "#4A422E" 
theme.tasklist_bg_focus            			    = "#C4B181"
theme.tasklist_fg_focus            				= "#000000"
theme.border_width                       	       	= dpi(2)
theme.border_normal                         	    = "#3F3F3F"
theme.border_focus                               	= "#6F6F6F"
theme.border_marked                        	    = "#CC9393"
theme.titlebar_bg_focus                        	= "#3F3F3F" 
theme.titlebar_bg_normal                      	= "#3F3F3F"
theme.titlebar_bg_focus                       		= theme.bg_focus
theme.titlebar_bg_normal                      	= theme.bg_normal
theme.titlebar_fg_focus                          	= theme.fg_focus
theme.menu_height                               	= dpi(25)
theme.menu_width                                	= dpi(260)
theme.menu_submenu_icon                 	= theme.dir .. "/icons/submenu.png"
theme.awesome_icon                             	= theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel                     	= theme.dir .. "/icons/square_a.png"
theme.taglist_squares_unsel                 	= theme.dir .. "/icons/square_b.png"
theme.layout_spiral                               	= theme.dir .. "/icons/spiral.png"
theme.layout_floating                             	= theme.dir .. "/icons/floating.png"
theme.widget_ac                                   		= theme.dir .. "/icons/ac.png"
theme.widget_battery                    		    = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                     	= theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                	= theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                 	= theme.dir .. "/icons/mem.png"
theme.widget_temp                                 	= theme.dir .. "/icons/temp.png"
theme.widget_vol                                     	= theme.dir .. "/icons/vol.png"
theme.widget_vol_low                             	= theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                               	= theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                          	= theme.dir .. "/icons/vol_mute.png"
theme.widget_task                               		= theme.dir .. "/icons/task.png"
theme.widget_scissors                       		= theme.dir .. "/icons/scissors.png"
theme.widget_weather                            	= theme.dir .. "/icons/dish.png"
theme.tasklist_plain_task_name          		= true
theme.tasklist_disable_icon                  	= true
theme.useless_gap                               		= 5

local markup = lain.util.markup
local separators = lain.util.separators


-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = "Iosevka Slab Medium 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})



-- Taskwarrior
--local task = wibox.widget.imagebox(theme.widget_task)
--lain.widget.contrib.task.attach(task, {
    -- do not colorize output
--    show_cmd = "task | sed -r 's/\\x1B\\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g'"
--})
--task:buttons(my_table.join(awful.button({}, 1, lain.widget.contrib.task.prompt)))


-- ALSA volume
theme.volume = lain.widget.alsabar({
    --togglechannel = "IEC958,3",
    notification_preset = { font = theme.font, fg = theme.fg_normal },
})

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

--[[ Weather
https://openweathermap.org/
Type in the name of your city
Copy/paste the city code in the URL to this file in city_id
--]]
local weathericon = wibox.widget.imagebox(theme.widget_weather)
theme.weather = lain.widget.weather({
    city_id = 524901, -- placeholder (Moscow)
    notification_preset = { font = "Noto Sans Mono Medium 10", fg = theme.fg_normal },
    weather_na_markup = markup.fontfg(theme.font, "#ffffff", "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, "#ffffff", descr .. " @ " .. units .. "°C "))
    end
})


-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                widget:set_markup(markup.font(theme.font, " AC "))
                baticon:set_image(theme.widget_ac)
                return
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup()
            baticon:set_image(theme.widget_ac)
        end
    end
})

-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(theme.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(theme.widget_vol_low)
        else
            volicon:set_image(theme.widget_vol)
        end

        widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "% "))
    end
})

-- Separators
local arrow = separators.arrow_left

function theme.powerline_rl(cr, width, height)
    local arrow_depth, offset = height/2, 0

    -- Avoid going out of the (potential) clip area
    if arrow_depth < 0 then
        width  =  width + 2*arrow_depth
        offset = -arrow_depth
    end

    cr:move_to(offset + arrow_depth         , 0        )
    cr:line_to(offset + width               , 0        )
    cr:line_to(offset + width - arrow_depth , height/2 )
    cr:line_to(offset + width               , height   )
    cr:line_to(offset + arrow_depth         , height   )
    cr:line_to(offset                       , height/2 )

    cr:close_path()
end

local function pl(widget, bgcolor, padding)
    return wibox.container.background(wibox.container.margin(widget, dpi(16), dpi(16)), bgcolor, theme.powerline_rl)
end

function theme.at_screen_connect(s)
    -- Quake application
   -- s.quake = lain.util.quake({ app = awful.util.terminal })
   s.quake = lain.util.quake({ app = "urxvt", height = 0.50, argname = "--name %s" })



    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- All tags open with layout 1
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(22), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            pl(wibox.widget { volicon, theme.volume.widget, layout = wibox.layout.align.horizontal }, "#D05407"),
            pl(wibox.widget { memicon, mem.widget, layout = wibox.layout.align.horizontal }, "#EBC580"),
            pl(wibox.widget { weathericon, theme.weather.widget, layout = wibox.layout.align.horizontal }, "#D05407"),
            pl(wibox.widget { baticon, bat.widget, layout = wibox.layout.align.horizontal }, "#EBC580"),
        },
    }
end

return theme
