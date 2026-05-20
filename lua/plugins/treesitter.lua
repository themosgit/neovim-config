return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = { "rust", "zig", "java",
                                 "cpp", "c", "lua", "vim", "vimdoc",
                                 "query", "markdown", "markdown_inline", "nix" },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
        }
    end
}
