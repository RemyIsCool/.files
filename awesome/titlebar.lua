return function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	local top_titlebar = awful.titlebar(c, { size = 40 })

	local close = awful.titlebar.widget.closebutton(c)
	local maximized = awful.titlebar.widget.maximizedbutton(c)
	local floating = awful.titlebar.widget.floatingbutton(c)

	close:connect_signal("mouse::enter", function()
		close.opacity = 0.75
	end)
	close:connect_signal("mouse::leave", function()
		close.opacity = 1.0
	end)
	maximized:connect_signal("mouse::enter", function()
		maximized.opacity = 0.75
	end)
	maximized:connect_signal("mouse::leave", function()
		maximized.opacity = 1.0
	end)
	floating:connect_signal("mouse::enter", function()
		floating.opacity = 0.75
	end)
	floating:connect_signal("mouse::leave", function()
		floating.opacity = 1.0
	end)

	top_titlebar:setup {
		{
			{
				{
					close,
					maximized,
					floating,
					spacing = 10,
					layout = wibox.layout.fixed.horizontal()
				},
				widget = wibox.container.margin,
				margins = 8
			},
			{ -- Middle
				{ -- Title
					align  = "center",
					widget = awful.titlebar.widget.titlewidget(c),
					font   = "Iosevka Bold 12"
				},
				buttons = buttons,
				layout  = wibox.layout.flex.horizontal
			},
			nil,
			layout = wibox.layout.align.horizontal
		},
		bottom = 6,
		color = "#020127",
		widget = wibox.container.margin
	}
end
