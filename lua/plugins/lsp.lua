return {
    { 'mason-org/mason.nvim', tag = 'v2.0.0', pin = true, lazy = false, opts = {} },
    {
        'mason-org/mason-lspconfig.nvim',
        tag = 'v2.0.0',
        pin = true,
        lazy = false,
        dependencies = {'mason-org/mason.nvim'},
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'clangd',
                    'rust_analyzer',
                    'ts_ls',
		            'html',
		            'cssls',
		            'bashls',
		            'fish_lsp',
                    'jdtls',
                    'zls',
		            'asm_lsp',
                },
                automatic_installation = true,
            })
        end
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {'hrsh7th/cmp-nvim-lsp'},
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                sources = {
                    {name = 'nvim_lsp'},
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                }),
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        tag = 'v1.8.0',
        pin = true,
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'mason-org/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
        },
        config = function()
            -- Suppress the config not found warnings (they're false positives in newer Neovim)
            local notify = vim.notify
            vim.notify = function(msg, ...)
                if msg:match("config not found") then
                    return
                end
                notify(msg, ...)
            end

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = {buffer = event.buf}
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
                    vim.keymap.set({'n', 'x'}, '<F3>', function()
                        vim.lsp.buf.format({async = true})
                    end, opts)
                    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)

                    vim.opt.signcolumn = 'yes'
                end,
            })

            local lspconfig = require('lspconfig')

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = {'vim'},
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            lspconfig.clangd.setup({
                capabilities = capabilities,
            })

            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            allFeatures = true,
                        },
                    },
                },
            })

            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })

            lspconfig.html.setup({
                capabilities = capabilities,
                init_options = {
                    provideFormatter = true,
                    embeddedLanguages = {
                        css = true,
                        javascript = true
                    }
                }
            })

            lspconfig.cssls.setup({
                capabilities = capabilities,
                init_options = {
                    provideFormatter = true
                }
            })

            lspconfig.bashls.setup({
                capabilities = capabilities,
            })

            lspconfig.fish_lsp.setup({
                capabilities = capabilities,
            })

            lspconfig.jdtls.setup({
                capabilities = capabilities,
            })

            lspconfig.zls.setup({
                capabilities = capabilities,
            })

            lspconfig.asm_lsp.setup({
                capabilities = capabilities,
            })

        end
    },
}
