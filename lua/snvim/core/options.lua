local settings = require "snvim.utils.settings"
local config = settings.get_settings("options")

-- Only load headless options if we're in headless mode
if #vim.api.nvim_list_uis() == 0 then
    for k, v in pairs(config.headless_options) do
        vim.opt[k] = v
    end
    return
end

-- Load regular settings otherwise
for k, v in pairs(config.default_options) do
    vim.opt[k] = v
end

for k, v in pairs(config.append_options) do
    if type(v) == "table" then
        for _, e in pairs(v) do
            vim.opt[k]:append(e)
        end
    else
        vim.opt[k]:append(v)
    end
end
