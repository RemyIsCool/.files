pcall(require, "luarocks.loader")

require("require")
require("awful.hotkeys_popup.keys")
require("startup")

beautiful.init("/home/remy/.config/awesome/theme.lua")

require("defaults")
require("layouts")
require("bar")
require("binds")
require("rules")
require("signals")
