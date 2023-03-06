local M = {}

local path_sep = vim.loop.os_uname().version:match "Windows" and "\\" or "/"

---Join path segments that were passed as input
---@return string
function M.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

---Checks whether a given path exists and is a file.
--@param path (string) path to check
--@returns (bool)
function M.is_file(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file" or false
end

---Checks whether a given path exists and is a directory
--@param path (string) path to check
--@returns (bool)
function M.is_directory(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory" or false
end

M.runtime_dir = vim.call("stdpath", "data") -- ~/.local/share/nvim
M.config_dir = vim.call("stdpath", "config") -- ~/.config/nvim
M.cache_dir = vim.call("stdpath", "cache") -- ~/.cache/nvim
M.pack_dir = M.join_paths(M.runtime_dir, "site", "pack")
M.plugins_dir = M.join_paths(M.pack_dir, "lazy", "opt")
M.undodir = M.join_paths(M.cache_dir, "undo")

return M
