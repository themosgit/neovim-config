vim.keymap.set("n", "<space>ex", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<space>p", "\"_dP")

vim.keymap.set("n", "<space>y", "\"+y")
vim.keymap.set("v", "<space>y", "\"+y")
vim.keymap.set("n", "<space>Y", "\"+Y")

vim.keymap.set("n", "<space>d", "\"_d")
vim.keymap.set("v", "<space>d", "\"_d")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>fo", function()
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<space>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<space>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<space>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<space>x", "<cmd>!chmod +x %<CR>", { silent = true })
