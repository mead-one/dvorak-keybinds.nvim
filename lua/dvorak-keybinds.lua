-- vim:ts=2:shiftwidth=2:expandtab:cc=81:
-- Keybinds chosen specifically for Dvorak-GB keymap

local M = {}

M.enabled = false
-- Snapshot mappings before setting them
M.baseline = {}

--------------------------------------------------------------------------------
-- Keymap tables
--------------------------------------------------------------------------------

-- Keybinds for normal, visual, select, and operator-pending mode
local function global_keybinds()
	return {
		-- (t) Navigate down (display lines - same line if wrapped text)
		{ lhs = "t", rhs = M.opts.visual_line_navigation and "gj" or "j" },
		-- (n) Navigate up (display lines - same line if wrapped text)
		{ lhs = "n", rhs = M.opts.visual_line_navigation and "gk" or "k" },
		-- (s) Navigate right (h) Navigate left
		{ lhs = "s", rhs = "l" },
		-- (h) remains the same
	}
end

local normal_keybinds = {
	-- (j) Next search result
	{ lhs = "j", rhs = "n" },
	-- (J) Previous search result
	{ lhs = "J", rhs = "N" },
	-- (S) Bottom of screen (H) Top of screen
	{ lhs = "S", rhs = "L" },
	-- (<leader>t{char}) Till character
	{ lhs = "<leader>t", rhs = "t" },
	-- (<leader>T{char}) Till character backwards
	{ lhs = "<leader>T", rhs = "T" },
}

local insert_keybinds = {
	-- (Ctrl+d) Move cursor left
	{ lhs = "<C-h>", rhs = "<Left>" },
	-- (Ctrl+h) Move cursor down
	{ lhs = "<C-t>", rhs = "<Down>" },
	-- (Ctrl+t) Move cursor up
	{ lhs = "<C-n>", rhs = "<Up>" },
	-- (Ctrl+n) Move cursor right
	{ lhs = "<C-s>", rhs = "<Right>" },
}

local punctuation_keybinds = {
	-- (-) End of line
	{ lhs = "-", rhs = "$" },
	-- (_) Start of line
	{ lhs = "_", rhs = "^" },
}

local window_keybinds = {
	-- (Ctrl+w d) Navigate to window left
	{ lhs = "<C-w>h", rhs = "<cmd>wincmd h<CR>" },
	-- (Ctrl+w h) Navigate to window down
	{ lhs = "<C-w>t", rhs = "<cmd>wincmd j<CR>" },
	-- (Ctrl+w t) Navigate to window up
	{ lhs = "<C-w>n", rhs = "<cmd>wincmd k<CR>" },
	-- (Ctrl+w n) Navigate to window right
	{ lhs = "<C-w>s", rhs = "<cmd>wincmd l<CR>" },
	-- (Ctrl+w z) Split window horizontally (replace <C-w>s)
	{ lhs = "<C-w>z", rhs = "<cmd>split<CR>" },
}

local buffer_keybinds = {
	{ lhs = "<leader>h", qwerty = "<leader>h", rhs = "<cmd>bp<CR>" },
	{ lhs = "<leader>s", qwerty = "<leader>l", rhs = "<cmd>bn<CR>" },
}

local vim_tmux_keybinds = {
	-- (Ctrl+h) Focus window left
	{ lhs = "<C-h>", qwerty = "<C-h>", rhs = "<cmd>TmuxNavigateLeft<CR>" },
	-- (Ctrl+t) Focus window below
	{ lhs = "<C-t>", qwerty = "<C-j>", rhs = "<cmd>TmuxNavigateDown<CR>" },
	-- (Ctrl+n) Focus window above
	{ lhs = "<C-n>", qwerty = "<C-k>", rhs = "<cmd>TmuxNavigateUp<CR>" },
	-- (Ctrl+s) Focus window right
	{ lhs = "<C-s>", qwerty = "<C-l>", rhs = "<cmd>TmuxNavigateRight<CR>" },
}

local nvim_tmux_keybinds = {
	-- (Ctrl+h) Focus window left
	{ lhs = "<C-h>", qwerty = "<C-h>", rhs = "<cmd>NvimTmuxNavigateLeft<CR>" },
	-- (Ctrl+t) Focus window below
	{ lhs = "<C-t>", qwerty = "C-j>", rhs = "<cmd>NvimTmuxNavigateDown<CR>" },
	-- (Ctrl+n) Focus window above
	{ lhs = "<C-n>", qwerty = "<C-k>", rhs = "<cmd>NvimTmuxNavigateUp<CR>" },
	-- (Ctrl+s) Focus window right
	{ lhs = "<C-s>", qwerty = "<C-l>", rhs = "<cmd>NvimTmuxNavigateRight<CR>" },
}

local smart_splits_keybinds = {
	{ lhs = "<C-t>", qwerty = "<C-j>", rhs = "<cmd>lua require('smart-splits').move_cursor_down()<CR>" },
	{ lhs = "<C-n>", qwerty = "<C-k>", rhs = "<cmd>lua require('smart-splits').move_cursor_up()<CR>" },
	{ lhs = "<C-s>", qwerty = "<C-l>", rhs = "<cmd>lua require('smart-splits').move_cursor_right()<CR>" },
	{ lhs = "<A-t>", qwerty = "<A-j>", rhs = "<cmd>lua require('smart-splits').resize_down()<CR>" },
	{ lhs = "<A-n>", qwerty = "<A-k>", rhs = "<cmd>lua require('smart-splits').resize_up()<CR>" },
	{ lhs = "<A-s>", qwerty = "<A-l>", rhs = "<cmd>lua require('smart-splits').resize_right()<CR>" },
}

--------------------------------------------------------------------------------
-- Plugin detection
--------------------------------------------------------------------------------

local function has_plugin(name, command)
	return package.loaded[name] or vim.fn.exists(command) > 0
end

local plugin_keybinds = {
	{
		check = function()
			return has_plugin("vim-tmux-navigator", ":TmuxNavigateLeft")
		end,
		binds = vim_tmux_keybinds,
	},
	{
		check = function()
			return has_plugin("nvim-tmux-navigation", ":NvimTmuxNavigateLeft")
		end,
		binds = nvim_tmux_keybinds,
	},
	{
		check = function()
			return has_plugin("smart-splits", ":SmartResizeMode")
		end,
		binds = smart_splits_keybinds,
	},
}

--------------------------------------------------------------------------------
-- Snapshot / restore
--------------------------------------------------------------------------------

-- Snapshot a key ONLY if we haven't already stored it (preserves originals)
local function snapshot_key(mode, lhs)
	M.baseline[mode] = M.baseline[mode] or {}
	if M.baseline[mode][lhs] ~= nil then
		return
	end

	for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
		if map.lhs == lhs then
			M.baseline[mode][lhs] = map
			return
		end
	end

	M.baseline[mode][lhs] = false -- explicitly unmapped
end

local function capture_baseline()
	local function snap(modes, lhs)
		for _, mode in ipairs(type(modes) == "string" and { modes } or modes) do
			snapshot_key(mode, lhs)
		end
	end

	for _, m in ipairs(global_keybinds()) do
		snap({ "n", "v", "s", "o" }, m.lhs)
	end
	for _, m in ipairs(normal_keybinds) do
		snap("n", m.lhs)
	end
	for _, m in ipairs(insert_keybinds) do
		snap("i", m.lhs)
	end
	for _, m in ipairs(punctuation_keybinds) do
		snap({ "n", "v", "s", "o" }, m.lhs)
	end
	for _, m in ipairs(window_keybinds) do
		snap("n", m.lhs)
	end
	for _, m in ipairs(buffer_keybinds) do
		snap("n", m.lhs)
	end
	-- Plugin keybinds use .dvorak as the lhs
	for _, group in ipairs(plugin_keybinds) do
		for _, m in ipairs(group.binds) do
			snap("n", m.lhs)
		end
	end
end

-- Snapshot all keys this plugin will touch, before we touch them
-- Restore all snapshotted keymaps to their pre-plugin state
local function restore_baseline()
	for mode, maps in pairs(M.baseline) do
		for lhs, map in pairs(maps) do
			-- Silently delete the current binding (may or may not exist)
			pcall(vim.keymap.del, mode, lhs)

			-- Restore original if there was one
			if map then
				vim.keymap.set(mode, lhs, map.rhs or map.callback, {
					silent = map.silent == 1,
					expr = map.expr == 1,
					noremap = map.noremap == 1,
					nowait = map.nowait == 1,
					desc = map.desc,
				})
			end
		end
	end

	M.baseline = {}
end

--------------------------------------------------------------------------------
-- Applying keymaps
--------------------------------------------------------------------------------

local function set(modes, lhs, rhs, opts)
	modes = type(modes) == "string" and { modes } or modes
	for _, mode in ipairs(modes) do
		snapshot_key(mode, lhs)
	end

	vim.keymap.set(modes, lhs, rhs, opts)
end

local o = { noremap = true, silent = true }

local function apply()
	for _, m in ipairs(global_keybinds()) do
		set({ "n", "v", "s", "o" }, m.lhs, m.rhs, o)
	end
	for _, m in ipairs(normal_keybinds) do
		set("n", m.lhs, m.rhs, o)
	end
	for _, m in ipairs(insert_keybinds) do
		set("i", m.lhs, m.rhs, o)
	end

	for _, group in ipairs(plugin_keybinds) do
		if group.check() then
			for _, m in ipairs(group.binds) do
				pcall(vim.keymap.del, "n", m.qwerty)
				set("n", m.lhs, m.rhs, o)
			end
		end
	end

	if M.opts.punctuation_line_navigation then
		for _, m in ipairs(punctuation_keybinds) do
			set({ "n", "v", "s", "o" }, m.lhs, m.rhs, o)
		end
	end

	if M.opts.window_management then
		for _, m in ipairs(window_keybinds) do
			set("n", m.lhs, m.rhs, o)
		end
	end

	if M.opts.leader_buffer_navigation then
		for _, m in ipairs(buffer_keybinds) do
			pcall(vim.keymap.del, "n", m.qwerty)
			set("n", m.lhs, m.rhs, o)
		end
	end
end

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

M.enable = function()
	M.enabled = true
	vim.g.dvorak_enabled = true
	apply()
	print("Dvorak keybinds enabled")
end

M.disable = function()
	if not M.enabled then
		return
	end

	restore_baseline()
	M.enabled = false
	vim.g.dvorak_enabled = false
	print("Dvorak keybinds disabled")
end

function M.toggle()
	if M.enabled then
		M.disable()
	else
		M.enable()
	end
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", {
		visual_line_navigation = false,
		punctuation_line_navigation = false,
		window_management = false,
		leader_buffer_navigation = false,
		auto_enable = true,
	}, opts or {})

	vim.api.nvim_create_user_command("DvorakToggle", function()
		M.toggle()
	end, { desc = "Toggle Dvorak keybinds" })
	vim.api.nvim_create_user_command("DvorakEnable", function()
		M.enable()
	end, { desc = "Enable Dvorak keybinds" })
	vim.api.nvim_create_user_command("DvorakDisable", function()
		M.disable()
	end, { desc = "Disable Dvorak keybinds" })

	if not M.opts.auto_enable then
		return
	end

	-- Capture baseline and (re)apply after all plugins have loaded.
	local function init()
		capture_baseline()
		M.enable()
	end

	-- VeryLazy fires in lazy.nvim distributions; UIEnter is the fallback.
	-- We guard with _baseline_captured so only the first event wins.
	local used_very_lazy = false

	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		once = true,
		callback = function()
			used_very_lazy = true
			init()
		end,
	})

	vim.api.nvim_create_autocmd("UIEnter", {
		once = true,
		callback = function()
			vim.schedule(function()
				if not used_very_lazy then
					init()
				end
			end)
		end,
	})
end

return M
