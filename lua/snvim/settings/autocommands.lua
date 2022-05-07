local M = {}

M.config = {
    _auto_resize = {
        { "VimResized", "*", "tabdo wincmd =" },
    },
    _git = {
        {"FileType", "gitcommit", "setlocal wrap"},
        {"FileType", "gitcommit", "setlocal spell"},
    },
    _markdown = {
        {"FileType", "markdown", "setlocal wrap"},
        {"FileType", "markdown", "setlocal spell"},
    },
    _easy_exit = {
        { "FileType", "qf,help,man", "nnoremap <silent> <buffer> q :close<CR>" },
        { "FileType", "floaterm", "nnoremap <silent> <buffer> q :q<CR>" },
        { "FileType", "lspinfo,lsp-installer,null-ls-info", "nnoremap <silent> <buffer> q :close<CR>" },
    },
    _abbreviations = {
        {"FileType", "c", "iabbrev forl for (int i=0; i<NUM; i++) {<CR><CR>}<Esc>?NUM<CR>cw"},
        {"FileType", "c", "iabbrev start #include <stdio.h><CR>#include <stdlib.h><CR><CR>int main() {<CR>printf(\"Hello World\");<CR>return 0;<CR>}"},
        {"FileType", "python", "iabbrev start def main() -> None<CR>    ...<CR><CR><Home>if __name__ == \"__main__\":<CR>main()<Esc>?\\.\\.\\.<CR>cw"}
    },
    _tabsize = {
        {"FileType", "c", "setlocal shiftwidth=2"},
        {"FileType", "python", "setlocal shiftwidth=4"},
    }
}

return M
