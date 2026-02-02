return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
    },
    {
        "Shatur/neovim-ayu",
        name = "ayu",
        config = function()
            require("ayu").setup({})
            vim.cmd("colorscheme ayu")
        end
    },
}
