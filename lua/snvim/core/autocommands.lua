local utils = require "snvim.utils.core"
local settings = require "snvim.utils.settings"

local definitions = settings.get_settings("autocommands")
for group_name, definition in pairs(definitions) do
    utils.define_augroup(group_name, definition)
end
