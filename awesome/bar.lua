mylauncher = awful.widget.launcher {
	image = beautiful.awesome_icon,
	command = "rofi -show drun"
}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mybattery = awful.widget.watch("cat /sys/class/power_supply/BAT0/capacity", 15, function(widget, stdout)
	local battery = tonumber(stdout)
	local icon = "󰂎"

	if battery > 10 then
		icon = "󰁺"
	end
	if battery > 20 then
		icon = "󰁻"
	end
	if battery > 30 then
		icon = "󰁼"
	end
	if battery > 40 then
		icon = "󰁽"
	end
	if battery > 50 then
		icon = "󰁾"
	end
	if battery > 60 then
		icon = "󰁿"
	end
	if battery > 70 then
		icon = "󰂀"
	end
	if battery > 80 then
		icon = "󰂁"
	end
	if battery > 90 then
		icon = "󰂂"
	end
	if battery > 95 then
		icon = "󰁹"
	end

	widget:set_text(icon .. " " .. stdout:gsub("\n", "") .. "%")
end)

-- local pinned_list = {
-- 	{ icon = "firefox",     command = "firefox" },
-- 	{ icon = "discord",     command = "flatpak run com.discordapp.Discord" },
-- 	{ icon = "alacritty",   command = "alacritty" },
-- 	{ icon = "pcmanfm",     command = "pcmanfm" },
-- 	{ icon = "thunderbird", command = "thunderbird" },
-- }
-- local pinned_app_widgets = {}
-- for index, value in ipairs(pinned_list) do
-- 	table.insert(pinned_app_widgets, wibox.widget {
-- 		widget = wibox.container.margin,
-- 		margins = 4,
-- 		{
-- 			widget = wibox.widget.imagebox,
-- 			image = "/usr/share/icons/Papirus-Dark/128x128/apps/" .. value.icon .. ".svg"
-- 		}
-- 	})
-- end
-- local pinned_apps = wibox.widget {
-- 	widget = wibox.container.margin,
-- 	margins = 1,
-- 	pinned_app_widgets
-- }

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Fix blurry icons :)
awesome.set_preferred_icon_size(128)
local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal(
				"request::activate",
				"tasklist",
				{ raise = true }
			)
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end))

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function() awful.layout.inc(1) end),
		awful.button({}, 3, function() awful.layout.inc(-1) end),
		awful.button({}, 4, function() awful.layout.inc(1) end),
		awful.button({}, 5, function() awful.layout.inc(-1) end)))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen          = s,
		filter          = awful.widget.taglist.filter.all,
		buttons         = taglist_buttons,
		layout          = {
			spacing = 8,
			layout = wibox.layout.fixed.horizontal
		},
		widget_template = {
			id = "text_role",
			widget = wibox.widget.textbox
		}
	}

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen          = s,
		filter          = awful.widget.tasklist.filter.currenttags,
		buttons         = tasklist_buttons,
		widget_template = {
			{
				{
					id     = "image",
					widget = wibox.widget.imagebox,
				},
				widget = wibox.container.margin,
				margins = 4
			},
			id = "background_role",
			widget = wibox.widget.background,
			create_callback = function(self, client)
				icon = client.icon or "/home/remy/.config/awesome/images/missing.png"

				if client.class == "org.mozilla.firefox" then
					icon = "/home/remy/.config/awesome/images/browser.png"
				end
				if client.class == "Alacritty" then
					icon = "/home/remy/.config/awesome/images/terminal.png"
				end
				if client.class == "Pcmanfm" then
					icon = "/home/remy/.config/awesome/images/files.png"
				end
				if client.class == "org.mozilla.thunderbird" then
					icon = "/home/remy/.config/awesome/images/mail.png"
				end
				if client.class == "org.mozilla.thunderbird" then
					icon = "/home/remy/.config/awesome/images/mail.png"
				end
				if client.class == "discord" then
					icon = "/home/remy/.config/awesome/images/message.png"
				end
				if client.class == "feh" then
					icon = "/home/remy/.config/awesome/images/image.png"
				end

				self:get_children_by_id("image")[1]:set_image(icon)
			end
		},
	}

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 50, bg = "#D8D2BC" })

	-- Add widgets to the wibox
	s.mywibox:setup {
		{
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = 16,
					mylauncher,
					s.mytaglist,
					s.mypromptbox,
				},
				widget = wibox.container.margin,
				margins = 4
			},
			{
				widget = wibox.container.margin,
				layout = wibox.layout.align.horizontal,
				expand = "outside",
				margins = 4,
				nil,
				{
					layout = wibox.layout.fixed.horizontal,
					{
						widget = wibox.container.margin,
						top = 4,
						bottom = 4,
						right = 2,
						{
							layout = wibox.layout.fixed.horizontal,
							spacing = 4,
							awful.widget.launcher {
								image = "/home/remy/.config/awesome/images/browser.png",
								command = "firefox"
							},
							awful.widget.launcher {
								image = "/home/remy/.config/awesome/images/terminal.png",
								command = "alacritty"
							},
							awful.widget.launcher {
								image = "/home/remy/.config/awesome/images/files.png",
								command = "pcmanfm"
							},
							awful.widget.launcher {
								image = "/home/remy/.config/awesome/images/mail.png",
								command = "thunderbird"
							},
							awful.widget.launcher {
								image = "/home/remy/.config/awesome/images/message.png",
								command = "flatpak run com.discordapp.Discord"
							}
						}
					},
					s.mytasklist,
				},
				nil
			},
			{ -- Right widgets
				{
					layout = wibox.layout.fixed.horizontal,
					mybattery,
					wibox.widget.systray(),
					mytextclock,
					s.mylayoutbox,
					spacing = 4
				},
				widget = wibox.container.margin,
				margins = 4
			}
		},
		widget = wibox.container.margin,
		top = 6,
		color = "#020127"
	}
end)
-- }}}
