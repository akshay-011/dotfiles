-- Make highlight groups transparent while preserving their other attributes
local function make_transparent(name)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if ok then
		hl.bg = nil
		vim.api.nvim_set_hl(0, name, hl)
	end
end

local groups = {
	-- transparent background
	"Normal",
	"NormalFloat",
	"FloatBorder",
	"Pmenu",
	"Terminal",
	"EndOfBuffer",
	"FoldColumn",
	"Folded",
	"SignColumn",
	"LineNr",
	"CursorLineNr",
	"StatusLine",
	"StatusLineNC",
	"NormalNC",
	"WhichKeyFloat",
	"TelescopeBorder",
	"TelescopeNormal",
	"TelescopePromptBorder",
	"TelescopePromptTitle",
	-- neotree
	"NeoTreeNormal",
	"NeoTreeNormalNC",
	"NeoTreeVertSplit",
	"NeoTreeWinSeparator",
	"NeoTreeEndOfBuffer",
	-- nvim-tree
	"NvimTreeNormal",
	"NvimTreeVertSplit",
	"NvimTreeEndOfBuffer",
	-- notify
	"NotifyINFOBody",
	"NotifyERRORBody",
	"NotifyWARNBody",
	"NotifyTRACEBody",
	"NotifyDEBUGBody",
	"NotifyINFOTitle",
	"NotifyERRORTitle",
	"NotifyWARNTitle",
	"NotifyTRACETitle",
	"NotifyDEBUGTitle",
	"NotifyINFOBorder",
	"NotifyERRORBorder",
	"NotifyWARNBorder",
	"NotifyTRACEBorder",
	"NotifyDEBUGBorder",
}

-- The current line goes see-through too, leaving its number to mark it. The
-- file tree marks its selection with that line alone, so it keeps the colour.
local cursorline = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })
if cursorline.bg then
	vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = cursorline.bg })
end
table.insert(groups, "CursorLine")

for _, name in ipairs(groups) do
	make_transparent(name)
end

-- Fix word/visual selection and LSP reference highlights:
-- Prevents white-on-white solid blocks and ensures high contrast readability
local function set_selection_highlights()
	-- Visual selection (when manually selecting text)
	vim.api.nvim_set_hl(0, "Visual", { bg = "#363d4a", fg = "#ffffff", bold = true })
	vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#363d4a", fg = "#ffffff", bold = true })

	-- LSP & cursor word references (when cursor rests on an identifier or variable)
	vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#2e3340", fg = "#ffffff", underline = true })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#2e3340", fg = "#ffffff", underline = true })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#3d3428", fg = "#ffd780", underline = true, bold = true })

	-- Illuminated word plugin references
	vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#2e3340", fg = "#ffffff", underline = true })
	vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#2e3340", fg = "#ffffff", underline = true })
	vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3d3428", fg = "#ffd780", underline = true, bold = true })
end

set_selection_highlights()

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
	pattern = "*",
	callback = function()
		set_selection_highlights()
	end,
})
