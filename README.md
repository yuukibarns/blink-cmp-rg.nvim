# blink-cmp-rg.nvim

Ripgrep source for [blink.cmp](https://github.com/Saghen/blink.cmp).

```lua
require("blink.cmp").setup({
	sources = {
		providers = {
			{
				"blink-cmp-rg",
				name = "Rg",
				-- options below are optional, these are the default values
				opts = {
					prefix_min_len = 3,
					get_command = function(context, prefix)
						return {
							"rg",
							"--heading",
							"--json",
							"--word-regexp",
							"--color",
							"never",
							"-i",
							prefix .. "[\\w_-]+",
							vim.fs.root(0, "git") or vim.fn.getcwd(),
						}
					end,
					get_prefix = function(context)
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local line = vim.api.nvim_get_current_line()
						local prefix = line:sub(1, col):match("[%w_-]+$") or ""
						return prefix
					end,
				},
			},
		},
	},
})
```
