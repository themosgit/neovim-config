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

            local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<space>ff', require('telescope.builtin').find_files)
			vim.keymap.set('n', '<space>fh', require('telescope.builtin').help_tags)
			vim.keymap.set('n', '<space>fs', function() 
				builtin.grep_string({ search = vim.fn.input(" Grep > ") });
			end)
			vim.keymap.set('n', '<space>fv', function()
                		builtin.find_files({ cwd = vim.fn.expand('~/.config/nvim') });
            			end)

            		vim.keymap.set('n', '<space>fn', function()
                		builtin.find_files({ cwd = vim.fn.expand('~/nix') });
            			end)
		end
          },
}
