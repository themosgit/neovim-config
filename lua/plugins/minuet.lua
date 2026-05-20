return {
    'milanglacier/minuet-ai.nvim',
    config = function()
        require('minuet').setup({
            provider = 'codestral',
            provider_options = {
                codestral = {
                    api_key = 'CODESTRAL_API_KEY',
                    end_point = 'https://codestral.mistral.ai/v1/fim/completions',
                    model = 'codestral-latest',
                    name = 'Codestral',
                    stream = true,
                },
            },
            virtualtext = {
                auto_trigger_ft = { '*' },
                keymap = {
                    accept = '<A-A>',
                    accept_line = '<A-a>',
                    accept_n_lines = '<A-z>',
                    prev = '<A-[>',
                    next = '<A-]>',
                    dismiss = '<A-e>',
                },
            },
            request_timeout = 10,
            throttle = 1000,
            debounce = 400,
            n_completions = 1,
            context_window = 8000,
        })
    end,
}
