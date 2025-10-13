local function setup_lsp()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require('lspconfig')

    -- Suppress false positive warnings
    local notify = vim.notify
    vim.notify = function(msg, ...)
        if msg:match("config not found") then return end
        notify(msg, ...)
    end

    -- LSP keybindings on attach
    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
            local opts = { buffer = event.buf }
            local buf_keymap = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
            end

            buf_keymap('n', 'K', vim.lsp.buf.hover, 'Hover')
            buf_keymap('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
            buf_keymap('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
            buf_keymap('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
            buf_keymap('n', 'go', vim.lsp.buf.type_definition, 'Go to type definition')
            buf_keymap('n', 'gr', vim.lsp.buf.references, 'References')
            buf_keymap('n', 'gs', vim.lsp.buf.signature_help, 'Signature help')
            buf_keymap('n', '<F2>', vim.lsp.buf.rename, 'Rename')
            buf_keymap('n', '<F3>', function() vim.lsp.buf.format({ async = true }) end, 'Format')
            buf_keymap('n', '<F4>', vim.lsp.buf.code_action, 'Code action')
            buf_keymap('x', '<F3>', function() vim.lsp.buf.format({ async = true }) end, 'Format')

            vim.opt.signcolumn = 'yes'
        end,
    })

    -- Server configurations
    local servers = {
        lua_ls = {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = { enable = false },
                },
            },
        },
        clangd = {
            cmd = { 'clangd', '--background-index' },
        },
        rust_analyzer = {
            settings = {
                ['rust-analyzer'] = {
                    cargo = { allFeatures = true },
                },
            },
        },
        html = {
            init_options = {
                provideFormatter = true,
                embeddedLanguages = { css = true, javascript = true },
            },
        },
        cssls = {
            init_options = { provideFormatter = true },
        },
        nil_ls = {
            settings = {
                ['nil'] = {
                    formatting = { command = { "nixfmt" } },
                },
            },
        },
    }

    for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_extend("force", { capabilities = capabilities }, config))
    end

    -- simple servers (no custom config needed)
    for _, server in ipairs({ 'bashls', 'jdtls', 'zls', 'asm_lsp' }) do
        lspconfig[server].setup({ capabilities = capabilities })
    end
end

return {
    { 'mason-org/mason.nvim', lazy = false, opts = {} },
    {
        'mason-org/mason-lspconfig.nvim',
        lazy = false,
        dependencies = { 'mason-org/mason.nvim' },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls', 'clangd', 'rust_analyzer', 'bashls',
                    'jdtls', 'zls', 'asm_lsp',
                },
                automatic_installation = true,
            })
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = { 'hrsh7th/cmp-nvim-lsp' },
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                sources = { { name = 'nvim_lsp' } },
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
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'mason-org/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
        },
        config = setup_lsp,
    },
}
