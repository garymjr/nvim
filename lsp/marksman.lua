local bin_name = "marksman"
local cmd = { bin_name, "server" }

return {
  cmd = cmd,
  filetypes = { "markdown", "markdown.mdx" },
  root_dir = { ".git", ".marksman.toml" },
  single_file_support = true,
}
