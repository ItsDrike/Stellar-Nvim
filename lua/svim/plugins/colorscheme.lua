local colorscheme = require("svim.vars").colorscheme

return {
  {
    "lunarvim/Onedarker.nvim",
    branch = "freeze",
    lazy = colorscheme ~= "onedarker",
    config = true,
  },
  {
    "lunarvim/lunar.nvim",
    version = false,
    lazy = colorscheme ~= "lunar",
  },
  {
    "folke/tokyonight.nvim",
    version = "*",
    lazy = not vim.startswith(colorscheme, "tokyonight"),
  },
}
