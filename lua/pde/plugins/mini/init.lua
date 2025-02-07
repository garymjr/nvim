local now, later = MiniDeps.now, MiniDeps.later

now(function()
	require("mini.extra").setup()
end)

later(function()
	require("mini.ai").setup()
end)

later(function()
	require("mini.bracketed").setup()
end)

later(function()
	require("pde.plugins.mini.bufremove")
end)

now(function()
	require("pde.plugins.mini.clue")
end)

later(function()
	require("mini.diff").setup()
end)

later(function()
	require("pde.plugins.mini.files")
end)

later(function()
	require("mini.git").setup()
end)

now(function()
	require("pde.plugins.mini.icons")
end)

later(function()
	require("pde.plugins.mini.pick")
end)

now(function()
	require("mini.statusline").setup()
end)

later(function()
	require("pde.plugins.mini.surround")
end)
