-- NOTE: This logging requires the structlog plugin
local M = {}

M.levels = {
    TRACE = 1,
    DEBUG = 2,
    INFO = 3,
    WARN = 4,
    ERROR = 5,
}
vim.tbl_add_reverse_lookup(M.levels)

M.log_level = Snvim.log_level
M.logfile = Snvim.structlog_path
M.override_notify = false

-- Initialize structlog logger and return it (requires structlog plugin)
-- @returns structlog.Logger
function M:init()
    local status_ok, structlog = pcall(require, "structlog")
    if not status_ok then
        error("Structlog plugin not found! Can't initialize logging")
    end

    local log_level = M.levels[M.log_level]

    local snvim_log = {
        sinks = {
            structlog.sinks.Console(log_level, {
                async = false,
                processors = {
                    structlog.processors.Namer(),
                    structlog.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 2 }),
                    structlog.processors.Timestamper "%H:%M:%S",
                },
                formatter = structlog.formatters.FormatColorizer(
                    "%s [%-5s] %s: %-30s",
                    { "timestamp", "level", "logger_name", "msg" },
                    { level = structlog.formatters.FormatColorizer.color_level() }
                ),
            }),
            structlog.sinks.File(M.levels.TRACE, M.logfile, {
                processors = {
                    structlog.processors.Namer(),
                    structlog.processors.StackWriter({ "line", "file" }, { max_parents = 3, stack_level = 2 }),
                    structlog.processors.Timestamper "%H:%M:%S",
                },
                formatter = structlog.formatters.Format(
                    "%s [%-5s] %s: %-30s",
                    { "timestamp", "level", "logger_name", "msg" }
                ),
            }),
        }
    }

    structlog.configure({ snvim = snvim_log })
    local logger = structlog.get_logger "snvim"

    -- Overwrite vim notify to use the snvim's logger
    if M.override_notify then
        vim.notify = function(msg, vim_log_level, opts)
            -- vim log level can be omitted
            if vim_log_level == nil then
                vim_log_level = M.levels["INFO"]
            elseif type(vim_log_level) == "string" then
                vim_log_level = M.levels[(vim_log_level):upper()] or M.levels["INFO"]
            else
                -- Our log levels are indexed from 1, nvim's start from 0
                vim_log_level = vim_log_level + 1
            end

        logger:log(vim_log_level, msg)
        end
    end
    return logger
end


-- Adds a log entry using the same logger each time (singleton pattern)
-- @param log_level string | "TRACE" | "DEBUG" | "INFO" | "WARN" | "ERROR"
-- @param msg string
-- @param event any
function M:add_entry(log_level, msg, event)
    if self.__single_logger then
        self.__single_logger:log(log_level, msg, event)
        return
    end

    self.__single_logger = self:init()
    self.__single_logger:log(log_level, msg, event)
end


-- Add a log entry at TRACE level
-- @param msg string
-- @param event any
function M:trace(msg, event)
    self:add_entry(self.levels.TRACE, msg, event)
end

-- Add a log entry at DEBUG level
-- @param msg string
-- @param event any
function M:debug(msg, event)
    self:add_entry(self.levels.DEBUG, msg, event)
end

-- Add a log entry at INFO level
-- @param msg string
-- @param event any
function M:info(msg, event)
    self:add_entry(self.levels.INFO, msg, event)
end

-- Add a log entry at WARN level
-- @param msg string
-- @param event any
function M:warn(msg, event)
    self:add_entry(self.levels.WARN, msg, event)
end

-- Add a log entry at ERROR level
-- @param msg string
-- @param event any
function M:error(msg, event)
    self:add_entry(self.levels.ERROR, msg, event)
end


return M
