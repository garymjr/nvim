local now, later = MiniDeps.now, MiniDeps.later

now(function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup {
        ensure_installed = {
            "bash",
            "comment",
            "css",
            "csv",
            "diff",
            "dockerfile",
            "eex",
            "elixir",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "go",
            "gomod",
            "gosum",
            "gotmpl",
            "gowork",
            "graphql",
            "heex",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "json5",
            "jsonc",
            "lua",
            "luadoc",
            "make",
            "markdown",
            "markdown_inline",
            "proto",
            "query",
            "regex",
            "scss",
            "sql",
            "templ",
            "terraform",
            "toml",
            "tsx",
            "typescript",
            "xml",
            "yaml",
        },
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
    }
end)

later(
    function()
        require("treesitter-context").setup {
            enable = true,
            max_lines = 3,
        }
    end
)
