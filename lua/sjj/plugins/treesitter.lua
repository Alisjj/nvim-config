return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({})

            -- Parsers to ensure are installed
            local ensure_installed = {
                "vimdoc",
                "javascript",
                "typescript",
                "c",
                "lua",
                "rust",
                "bash",
                "go",
                "python",
            }

            -- Auto-install missing parsers on startup
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    local installed = require("nvim-treesitter.config").get_installed("parsers")
                    local to_install = {}
                    for _, lang in ipairs(ensure_installed) do
                        if not vim.tbl_contains(installed, lang) then
                            table.insert(to_install, lang)
                        end
                    end
                    if #to_install > 0 then
                        vim.cmd("TSInstall " .. table.concat(to_install, " "))
                    end
                end,
                once = true,
            })

            -- Enable treesitter highlight and indent for all buffers
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
}
