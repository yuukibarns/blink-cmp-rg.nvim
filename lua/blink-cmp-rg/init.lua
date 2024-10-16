local function get_current_word_prefix()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()
	local prefix = line:sub(1, col):match("[%w_]*$") or ""
	return prefix
end

local RgSource = {}

function RgSource:new()
	return setmetatable({}, { __index = RgSource })
end

function RgSource:get_completions(_, resolve)
	local prefix = get_current_word_prefix()

	vim.fn.timer_start(1000, function()
		resolve({
			is_incomplete_forward = false,
			is_incomplete_backward = false,
			items = {
				{
					label = prefix .. "who",
					kind = vim.lsp.protocol.CompletionItemKind.Field,
					insertText = prefix .. "who",
				},
			},
		})
	end)
end

return RgSource
