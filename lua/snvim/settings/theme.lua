local M = {}

M.config = {
    colorscheme = "codedark",
    show_mode=true,
    listchars = {tab = " ", trail = "·"},
    show_cursor_line=true,
    show_line_numbers=true,
    show_relative_numbers=true,
    show_matching_brackets=true,
    enable_line_wrapping=false,
    vertical_scrolloff=5,
    horizontal_scrolloff=5,

    -- Make cursor line more noticable
    cursor_line_guibg = "#2b2b2b",
    cursor_line_ctermbg = "None",
    cursor_line_number_guifg = "#1f85de",
    cursor_line_number_ctermfg = "LightBlue",

    -- Show these languages in fenced markdown code blocks
    -- we can also map custom codeblock names to filetype names
    markdown_fenced_languages = {
        "sh", "bash", "zsh", "c", "asm", "rust", "haskell",
        "javascript", "js=javascript", "typescript", "ts=typescript",
        "python", "python3=python", "python2=python", "py=python",
        "cs", "csharp=cs", "cpp", "c++=cpp", "vim", "viml=vim",
        "dosini", "ini=dosini", "php", "html", "css", "java", "awk",
        "lua"
    }
}

return M
