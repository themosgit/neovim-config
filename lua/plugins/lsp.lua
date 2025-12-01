local function setup_lsp()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

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

    -- Lua LSP
    vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        capabilities = capabilities,
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
    })

    -- Clangd
    vim.lsp.config('clangd', {
        cmd = { 'clangd', '--background-index' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
        capabilities = capabilities,
    })

    -- Rust Analyzer
    vim.lsp.config('rust_analyzer', {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
        capabilities = capabilities,
        settings = {
            ['rust-analyzer'] = {
                cargo = { allFeatures = true },
            },
        },
    })

    -- HTML
    vim.lsp.config('html', {
        cmd = { 'vscode-html-language-server', '--stdio' },
        filetypes = { 'html', 'templ' },
        root_markers = { 'package.json', '.git' },
        capabilities = capabilities,
        init_options = {
            provideFormatter = true,
            embeddedLanguages = { css = true, javascript = true },
        },
    })

    -- CSS
    vim.lsp.config('cssls', {
        cmd = { 'vscode-css-language-server', '--stdio' },
        filetypes = { 'css', 'scss', 'less' },
        root_markers = { 'package.json', '.git' },
        capabilities = capabilities,
        init_options = { provideFormatter = true },
    })

    -- Nix
    vim.lsp.config('nil_ls', {
        cmd = { 'nil' },
        filetypes = { 'nix' },
        root_markers = { 'flake.nix', 'shell.nix', '.git' },
        capabilities = capabilities,
        settings = {
            ['nil'] = {
                formatting = { command = { "nixfmt" } },
            },
        },
    })

    -- Bash
    vim.lsp.config('bashls', {
        cmd = { 'bash-language-server', 'start' },
        filetypes = { 'sh' },
        root_markers = { '.git' },
        capabilities = capabilities,
    })

    -- Java
    vim.lsp.config('jdtls', {
        cmd = { 'jdtls' },
        filetypes = { 'java' },
        root_markers = { 'pom.xml', 'build.gradle', '.git' },
        capabilities = capabilities,
    })

    -- Zig
    vim.lsp.config('zls', {
        cmd = { 'zls' },
        filetypes = { 'zig', 'zir' },
        root_markers = { 'zls.json', 'build.zig', '.git' },
        capabilities = capabilities,
    })

    -- Assembly
    vim.lsp.config('asm_lsp', {
        cmd = { 'asm-lsp' },
        filetypes = { 'asm', 's', 'S' },
        root_markers = { '.git' },
        capabilities = capabilities,
    })

    -- OCaml
    vim.lsp.config('ocamllsp', {
        cmd = { 'ocamllsp' },
        filetypes = { 'ocaml', 'ocaml.menhir', 'ocaml.interface', 'ocaml.ocamllex', 'reason', 'dune' },
        root_markers = { '*.opam', 'esy.json', 'package.json', 'dune-project', 'dune-workspace', '.git' },
        capabilities = capabilities,
    })

    -- Enable all configured LSPs
    vim.lsp.enable({ 'lua_ls', 'clangd', 'rust_analyzer', 'html', 'cssls', 'nil_ls', 'bashls', 'jdtls', 'zls', 'asm_lsp', 'ocamllsp' })
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
