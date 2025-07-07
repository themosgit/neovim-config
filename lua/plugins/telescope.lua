return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
		},
		config = function()
			require('telescope').setup {
				pickers = {
					find_files = {
						theme = "ivy"
					}
				},
				extensions = {
					fzf = {}
				}
			}

			require("telescope").load_extension("fzf")
			vim.keymap.set('n', '<space>f', require('telescope.builtin').find_files)
			vim.keymap.set('n', '<space>fh', require('telescope.builtin').help_tags)
			vim.keymap.set('n', '<space>s', function() 
				require('telescope.builtin').grep_string({ search = vim.fn.input(" Grep > ") });
			end)
		end
          },
}
