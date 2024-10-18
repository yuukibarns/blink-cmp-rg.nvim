# blink-cmp-rg.nvim

Ripgrep source for [blink.cmp](https://github.com/Saghen/blink.cmp).

```lua
require("blink.cmp").setup({
	sources = {
		providers = {
			{ "blink.cmp.sources.lsp", name = "LSP" },
			{ "blink.cmp.sources.path", name = "Path", score_offset = 3 },
			{ "blink.cmp.sources.snippets", name = "Snippets", score_offset = -3 },
			{ "blink.cmp.sources.buffer", name = "Buffer", fallback_for = { "LSP" } },
			{
				"blink-cmp-rg",
				name = "Rg",
				-- options below are optional, these are the default values
				prefix_min_len = 3,
				get_command = function(prefix)
					return {
						"rg",
						"--heading",
						"--json",
						"--word-regexp",
						"--color",
						"never",
						prefix .. "[\\w_-]+",
						vim.fs.root(0, "git") or vim.fn.getcwd(),
					}
				end,
			},
		},
	},
})

```
