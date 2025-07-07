return {
	{
		'tpope/vim-fugitive',
		config = function() 
			vim.keymap.set("n", "<space>gs", vim.cmd.Git)
		end
	},
}
