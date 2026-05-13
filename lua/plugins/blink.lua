return {
    'Saghen/blink.cmp',
    lazy = false,
    build = function()
        require('blink.cmp').build():wait(60000)
    end,
    dependencies = { 
        'saghen/blink.lib',
        'milanglacier/minuet-ai.nvim',
        'rafamadriz/friendly-snippets' 
    },
    config = function()
        -- Configure Minuet-AI with Mistral
        require('minuet').setup({
            provider = 'openai_compatible',
            provider_options = {
                openai_compatible = {
                    api_key = 'MISTRAL_API_KEY',
                    end_point = 'https://api.mistral.ai/v1/chat/completions',
                    model = 'mistral-large-latest',
                    name = 'Mistral',
                    stream = true,
                    optional = {
                        max_tokens = 128,
                        temperature = 0.7,
                    },
                },
            },
            request_timeout = 10,
            throttle = 1000,
            debounce = 400,
            n_completions = 2,
            context_window = 8000,
            blink = {
                enable_auto_complete = true,
            },
        })
        
        local blink = require('blink-cmp')
        
        blink.setup({
            -- Performance
            completion = {
                trigger = {
                    prefetch_on_insert = false,
                },
            },
            
            -- Sources: minuet first for priority, then LSP
            sources = {
                default = { 'minuet', 'lsp', 'path', 'buffer', 'snippets' },
                providers = {
                    minuet = {
                        name = 'minuet',
                        module = 'minuet.blink',
                        async = true,
                        timeout_ms = 3000,
                        score_offset = 100,
                    },
                },
            },
            
            -- Keymaps
            keymap = {
                ['<A-y>'] = require('minuet').make_blink_map(),
                ['<CR>'] = {
                    function(cmp)
                        cmp.accept { auto_select = true }
                    end,
                },
                ['<Tab>'] = {
                    function(cmp)
                        cmp.select_next()
                    end,
                },
                ['<S-Tab>'] = {
                    function(cmp)
                        cmp.select_prev()
                    end,
                },
                ['<C-u>'] = {
                    function(cmp)
                        cmp.scroll_docs(-4)
                    end,
                },
                ['<C-d>'] = {
                    function(cmp)
                        cmp.scroll_docs(4)
                    end,
                },
                ['<C-e>'] = {
                    function(cmp)
                        cmp.dismiss()
                    end,
                },
                ['<C-Space>'] = {
                    function(cmp)
                        cmp.show()
                    end,
                },
            },
            
            -- UI Customization
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = 'normal',
                kind_icons = {
                    claude = '󰋦',
                    openai = '󱢆',
                    codestral = '󱎥',
                    gemini = '',
                    Mistral = '󱎥',
                },
            },
        })
    end,
}
