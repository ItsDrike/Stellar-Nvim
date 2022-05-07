local M = {}

M.config = {
    package_root = Snvim.pack_dir,
    compile_path = Snvim.compile_path,
    git = {
        clone_timeout = 300,
        subcommands = {
            -- this is more efficient than what Packer is using by default
            fetch = "fetch --no-tags --no-recurse-submodules --update-shallow --progress",
        }
    },
    log = {
        level = Snvim.log_level
    },
    max_jobs = 50,
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    }
}

return M
