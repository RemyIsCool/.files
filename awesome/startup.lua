-- Startup programs
awful.spawn.with_shell(
	'xinput set-prop "SYNA8018:00 06CB:CE67 Touchpad" "libinput Tapping Enabled" 1 &' ..
	"picom &" ..
	"xss-lock --transfer-sleep-lock -- i3lock -i /home/remy/Pictures/wallpaper.png --nofork &"
)
