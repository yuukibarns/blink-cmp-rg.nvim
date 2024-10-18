local RgSource = {}

function RgSource:new(config)
	config = config or {}
	return setmetatable({
		prefix_min_len = config.prefix_min_len or 3,
		get_root_dir = config.get_root_dir or function()
			return vim.fs.root(0, "git") or vim.fn.getcwd()
		end,
		word_pattern = config.word_pattern or "[\\w_-]+",
	}, { __index = RgSource })
end

function RgSource:get_completions(_, resolve)
	local prefix = require("blink.cmp.fuzzy").get_query()

	if string.len(prefix) < self.prefix_min_len then
		resolve()
		return
	end

	vim.system(
		{
			"rg",
			"--heading",
			"--json",
			"--word-regexp",
			"--color",
			"never",
			prefix .. self.word_pattern,
			self:get_root_dir(),
		},
		nil,
		function(result)
			if result.code ~= 0 then
				resolve()
				return
			end

			local items = {}
			local lines = vim.split(result.stdout, "\n")
			vim.iter(lines)
				:map(function(line)
					local ok, item = pcall(vim.json.decode, line)
					return ok and item or {}
				end)
				:filter(function(item)
					return item.type == "match"
				end)
				:map(function(item)
					return item.data.submatches
				end)
				:flatten()
				:each(function(submatch)
					items[submatch.match.text] = {
						label = submatch.match.text,
						kind = vim.lsp.protocol.CompletionItemKind.Text,
						insertText = submatch.match.text,
					}
				end)

			resolve({
				is_incomplete_forward = false,
				is_incomplete_backward = false,
				items = vim.tbl_values(items),
			})
		end
	)
end

return RgSource
