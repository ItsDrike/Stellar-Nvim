local uv = vim.loop

local M = {}

local os_name = vim.loop.os_uname().version
M.path_separator = os_name:match "Windows" and "\\" or "/"


-- Safely join paths together, regardless of the OS
--@param ... string @string paths to be joined together
--@returns string @Resulting path by joining the given paths by the OS-specific separator
function M.join_paths(...)
    return table.concat({ ... }, M.path_separator)
end



-- Split the path by separators into a list of it's sections
--@param path string
--@returns table<int, string>
function M.split_path(path)
    local pattern = string.format("([^%s]+)", M.path_separator)
    local parts = {}
    for part in string.gmatch(path, pattern) do
        table.insert(parts, part)
    end
    return parts
end


-- Check whether a given path exists and is a directory
--@param path string
--@returns bool
function M.is_directory(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "directory" or false
end


-- Check whether a given path exists and is a file
--@param path string
--@returns bool
function M.is_file(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "file" or false
end


---Write data to a file
---@param path string can be full or relative to `cwd`
---@param txt string|table text to be written, uses `vim.inspect` internally for tables
---@param flag string used to determine access mode, common flags: "w" for `overwrite` or "a" for `append`
function M.write_file(path, txt, flag)
  local data = type(txt) == "string" and txt or vim.inspect(txt)
  uv.fs_open(path, flag, 438, function(open_err, fd)
    assert(not open_err, open_err)
    uv.fs_write(fd, data, -1, function(write_err)
      assert(not write_err, write_err)
      uv.fs_close(fd, function(close_err)
        assert(not close_err, close_err)
      end)
    end)
  end)
end


return M
