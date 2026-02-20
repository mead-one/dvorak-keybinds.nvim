-- vim:ts=2:shiftwidth=2:expandtab:cc=81:
-- Keybinds chosen specifically for Dvorak-GB keymap

local M = {}

-- Snapshot mappings before setting them
M._saved_maps = {}

local function normalise_modes(modes)
	if type(modes) == "string" then
		return { modes }
	end
	return modes
end

local function save_map(modes, lhs)
	modes = normalise_modes(modes)

	M._saved_maps = M._saved_maps or {}

	for _, mode in ipairs(modes) do
		M._saved_maps[mode] = M._saved_maps[mode] or {}

		if M._saved_maps[mode][lhs] == nil then
			local found = false
			for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
				if map.lhs == lhs then
					M._saved_maps[mode][lhs] = map
					found = true
					break
				end
			end

			if not found then
				-- Explicitly store false if unmapped
				M._saved_maps[mode][lhs] = false
			end
		end
	end
end

-- Create a keymap, but create a snapshot first
M.map = function(mode, lhs, rhs, opts)
	save_map(mode, lhs)

	-- if should_apply(lhs, mode) then
	vim.keymap.set(mode, lhs, rhs, opts)
	-- end
end

-- Restore keymaps from snapshot
M.restore_maps = function()
	if not M._saved_maps then
		return
	end

	for mode, maps in pairs(M._saved_maps) do
		for lhs, map in pairs(maps) do
			pcall(vim.keymap.del, mode, lhs)

			if map then
				vim.keymap.set(
					mode,
					lhs,
					map.rhs({
						silent = map.silent == 1,
						expr = map.expr == 1,
						noremap = map.noremap == 1,
						nowait = map.nowait == 1,
						desc = map.desc,
					})
				)
			end
		end
	end

	M._saved_maps = {}
end

-- Keybinds for normal, visual, select, and operator-pending mode
local function get_global_keybinds()
	return {
		-- (t) Navigate down (display lines - same line if wrapped text)
		{ shortcut = "t", command = M.opts.visual_line_navigation and "gj" or "j" },
		-- (n) Navigate up (display lines - same line if wrapped text)
		{ shortcut = "n", command = M.opts.visual_line_navigation and "gk" or "k" },
		-- (s) Navigate right (h) Navigate left
		{ shortcut = "s", command = "l" },
		-- (h) remains the same
	}
end

local normal_mode_keybinds = {
	-- (j) Next search result
	{ shortcut = "j", command = "n" },
	-- (J) Previous search result
	{ shortcut = "J", command = "N" },
	-- (S) Bottom of screen (H) Top of screen
	{ shortcut = "S", command = "L" },
	-- (<leader>t{char}) Till character
	{ shortcut = "<leader>t", command = "t" },
	-- (<leader>T{char}) Till character backwards
	{ shortcut = "<leader>T", command = "T" },
}

local insert_mode_keybinds = {
	-- (Ctrl+d) Move cursor left
	{ shortcut = "<C-h>", command = "<Left>" },
	-- (Ctrl+h) Move cursor down
	{ shortcut = "<C-t>", command = "<Down>" },
	-- (Ctrl+t) Move cursor up
	{ shortcut = "<C-n>", command = "<Up>" },
	-- (Ctrl+n) Move cursor right
	{ shortcut = "<C-s>", command = "<Right>" },
}

local punctuation_line_navigation_keybinds = {
	-- (-) End of line
	{ shortcut = "-", command = "$" },
	-- (_) Start of line
	{ shortcut = "_", command = "^" },
}

local window_management_keybinds = {
	-- (Ctrl+w d) Navigate to window left
	{ shortcut = "<C-w>h", command = "<cmd>wincmd h<CR>" },
	-- (Ctrl+w h) Navigate to window down
	{ shortcut = "<C-w>t", command = "<cmd>wincmd j<CR>" },
	-- (Ctrl+w t) Navigate to window up
	{ shortcut = "<C-w>n", command = "<cmd>wincmd k<CR>" },
	-- (Ctrl+w n) Navigate to window right
	{ shortcut = "<C-w>s", command = "<cmd>wincmd l<CR>" },
	-- (Ctrl+w z) Split window horizontally (replace <C-w>s)
	{ shortcut = "<C-w>z", command = "<cmd>split<CR>" },
}

local leader_buffer_navigation_keybinds = {
	{ dvorak = "<leader>h", qwerty = "<leader>h", command = "<cmd>bp<CR>" },
	{ dvorak = "<leader>s", qwerty = "<leader>l", command = "<cmd>bn<CR>" },
}

local vim_tmux_keybinds = {
	-- (Ctrl+h) Focus window left
	{ dvorak = "<C-h>", qwerty = "<C-h>", command = "<cmd>TmuxNavigateLeft<CR>" },
	-- (Ctrl+t) Focus window below
	{ dvorak = "<C-t>", qwerty = "<C-j>", command = "<cmd>TmuxNavigateDown<CR>" },
	-- (Ctrl+n) Focus window above
	{ dvorak = "<C-n>", qwerty = "<C-k>", command = "<cmd>TmuxNavigateUp<CR>" },
	-- (Ctrl+s) Focus window right
	{ dvorak = "<C-s>", qwerty = "<C-l>", command = "<cmd>TmuxNavigateRight<CR>" },
}

local nvim_tmux_keybinds = {
	-- (Ctrl+h) Focus window left
	{ dvorak = "<C-h>", qwerty = "<C-h>", command = "<cmd>NvimTmuxNavigateLeft<CR>" },
	-- (Ctrl+t) Focus window below
	{ dvorak = "<C-t>", qwerty = "C-j>", command = "<cmd>NvimTmuxNavigateDown<CR>" },
	-- (Ctrl+n) Focus window above
	{ dvorak = "<C-n>", qwerty = "<C-k>", command = "<cmd>NvimTmuxNavigateUp<CR>" },
	-- (Ctrl+s) Focus window right
	{ dvorak = "<C-s>", qwerty = "<C-l>", command = "<cmd>NvimTmuxNavigateRight<CR>" },
}

local smart_splits_keybinds = {
	{ dvorak = "<C-t>", qwerty = "<C-j>", command = "<cmd>lua require('smart-splits').move_cursor_down()<CR>" },
	{ dvorak = "<C-n>", qwerty = "<C-k>", command = "<cmd>lua require('smart-splits').move_cursor_up()<CR>" },
	{ dvorak = "<C-s>", qwerty = "<C-l>", command = "<cmd>lua require('smart-splits').move_cursor_right()<CR>" },
	{ dvorak = "<A-t>", qwerty = "<A-j>", command = "<cmd>lua require('smart-splits').resize_down()<CR>" },
	{ dvorak = "<A-n>", qwerty = "<A-k>", command = "<cmd>lua require('smart-splits').resize_up()<CR>" },
	{ dvorak = "<A-s>", qwerty = "<A-l>", command = "<cmd>lua require('smart-splits').resize_right()<CR>" },
}

-- Snapshot keymaps before overwriting them
M._saved_maps = {}
M._baseline_captured = false
M.enabled = false

-- Ensure even single modes in mappings are inside a table
local function normalise_modes(modes)
	if type(modes) == "string" then
		return { modes }
	end
	return modes
end

-- Snapshot a key ONLY if we haven't already stored it (preserves originals)
local function snapshot_key(mode, lhs)
	M._saved_maps[mode] = M._saved_maps[mode] or {}
	if M._saved_maps[mode][lhs] ~= nil then
		return -- already captured, don't overwrite
	end

	local found = false
	for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
		if map.lhs == lhs then
			M._saved_maps[mode][lhs] = map
			found = true
			break
		end
	end

	if not found then
		M._saved_maps[mode][lhs] = false -- explicitly unmapped
	end
end

-- Set a keymap, snapshotting the current binding first if baseline captured
M.map = function(modes, lhs, rhs, opts)
	modes = normalise_modes(modes)

	-- Only snapshot here if baseline was already captured (i.e. not first-run)
	if M._baseline_captured then
		for _, mode in ipairs(modes) do
			snapshot_key(mode, lhs)
		end
	end

	vim.keymap.set(modes, lhs, rhs, opts)
end

-- Snapshot all keys this plugin will touch, before we touch them
M.capture_baseline = function()
	if M._baseline_captured then
		return
	end

	-- Build a unified list of all (mode, lhs) pairs we will map
	local to_snapshot = {}

	local function add(modes, lhs)
		modes = normalise_modes(modes)
		for _, mode in ipairs(modes) do
			table.insert(to_snapshot, { mode = mode, lhs = lhs })
		end
	end

	for _, mapping in ipairs(get_global_keybinds()) do
		add({ "n", "v", "s", "o" }, mapping.shortcut)
	end
	for _, mapping in ipairs(normal_mode_keybinds) do
		add("n", mapping.shortcut)
	end
	for _, mapping in ipairs(insert_mode_keybinds) do
		add("i", mapping.shortcut)
	end
	for _, mapping in ipairs(punctuation_line_navigation_keybinds) do
		add({ "n", "v", "s", "o" }, mapping.shortcut)
	end
	for _, mapping in ipairs(window_management_keybinds) do
		add("n", mapping.shortcut)
	end
	-- Plugin keybinds use .dvorak as the lhs
	for _, mapping in ipairs(vim_tmux_keybinds) do
		add("n", mapping.dvorak)
	end
	for _, mapping in ipairs(nvim_tmux_keybinds) do
		add("n", mapping.dvorak)
	end
	for _, mapping in ipairs(smart_splits_keybinds) do
		add("n", mapping.dvorak)
	end
	for _, mapping in ipairs(leader_buffer_navigation_keybinds) do
		add("n", mapping.dvorak)
	end

	M._saved_maps = {}
	for _, entry in ipairs(to_snapshot) do
		snapshot_key(entry.mode, entry.lhs)
	end

	M._baseline_captured = true
end

-- Restore all snapshotted keymaps to their pre-plugin state
M.restore_maps = function()
	for mode, maps in pairs(M._saved_maps) do
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

	M._saved_maps = {}
end

-- Keybinds for normal, visual, select, and operator-pending mode
local function get_global_keybinds()
	return {
		{ shortcut = "t", command = M.opts.visual_line_navigation and "gj" or "j" },
		{ shortcut = "n", command = M.opts.visual_line_navigation and "gk" or "k" },
		{ shortcut = "s", command = "l" },
	}
end

local normal_mode_keybinds = {
	{ shortcut = "j", command = "n" },
	{ shortcut = "J", command = "N" },
	{ shortcut = "S", command = "L" },
	{ shortcut = "<leader>t", command = "t" },
	{ shortcut = "<leader>T", command = "T" },
}

local insert_mode_keybinds = {
	{ shortcut = "<C-h>", command = "<Left>" },
	{ shortcut = "<C-t>", command = "<Down>" },
	{ shortcut = "<C-n>", command = "<Up>" },
	{ shortcut = "<C-s>", command = "<Right>" },
}

local punctuation_line_navigation_keybinds = {
	{ shortcut = "-", command = "$" },
	{ shortcut = "_", command = "^" },
}

local window_management_keybinds = {
	{ shortcut = "<C-w>h", command = "<cmd>wincmd h<CR>" },
	{ shortcut = "<C-w>t", command = "<cmd>wincmd j<CR>" },
	{ shortcut = "<C-w>n", command = "<cmd>wincmd k<CR>" },
	{ shortcut = "<C-w>s", command = "<cmd>wincmd l<CR>" },
	{ shortcut = "<C-w>z", command = "<cmd>split<CR>" },
}

local leader_buffer_navigation_keybinds = {
	{ dvorak = "<leader>h", qwerty = "<leader>h", command = "<cmd>bp<CR>" },
	{ dvorak = "<leader>s", qwerty = "<leader>l", command = "<cmd>bn<CR>" },
}

local vim_tmux_keybinds = {
	{ dvorak = "<C-h>", qwerty = "<C-h>", command = "<cmd>TmuxNavigateLeft<CR>" },
	{ dvorak = "<C-t>", qwerty = "<C-j>", command = "<cmd>TmuxNavigateDown<CR>" },
	{ dvorak = "<C-n>", qwerty = "<C-k>", command = "<cmd>TmuxNavigateUp<CR>" },
	{ dvorak = "<C-s>", qwerty = "<C-l>", command = "<cmd>TmuxNavigateRight<CR>" },
}

local nvim_tmux_keybinds = {
	{ dvorak = "<C-h>", qwerty = "<C-h>", command = "<cmd>NvimTmuxNavigateLeft<CR>" },
	{ dvorak = "<C-t>", qwerty = "<C-j>", command = "<cmd>NvimTmuxNavigateDown<CR>" }, -- fixed: was "C-j>"
	{ dvorak = "<C-n>", qwerty = "<C-k>", command = "<cmd>NvimTmuxNavigateUp<CR>" },
	{ dvorak = "<C-s>", qwerty = "<C-l>", command = "<cmd>NvimTmuxNavigateRight<CR>" },
}

local smart_splits_keybinds = {
	{ dvorak = "<C-t>", qwerty = "<C-j>", command = "<cmd>lua require('smart-splits').move_cursor_down()<CR>" },
	{ dvorak = "<C-n>", qwerty = "<C-k>", command = "<cmd>lua require('smart-splits').move_cursor_up()<CR>" },
	{ dvorak = "<C-s>", qwerty = "<C-l>", command = "<cmd>lua require('smart-splits').move_cursor_right()<CR>" },
	{ dvorak = "<A-t>", qwerty = "<A-j>", command = "<cmd>lua require('smart-splits').resize_down()<CR>" },
	{ dvorak = "<A-n>", qwerty = "<A-k>", command = "<cmd>lua require('smart-splits').resize_up()<CR>" },
	{ dvorak = "<A-s>", qwerty = "<A-l>", command = "<cmd>lua require('smart-splits').resize_right()<CR>" },
}

local function tmux_navigator_available()
	return vim.g.loaded_tmux_navigator == 1 or vim.fn.exists(":TmuxNavigateLeft") > 0
end

local function tmux_navigation_available()
	return package.loaded["nvim-tmux-navigation"] or vim.fn.exists(":NvimTmuxNavigateLeft") > 0
end

local function smart_splits_available()
	return package.loaded["smart-splits"] or vim.fn.exists(":SmartResizeMode") > 0
end

M.apply_all_mappings = function()
	for _, mapping in ipairs(get_global_keybinds()) do
		M.map({ "n", "v", "s", "o" }, mapping.shortcut, mapping.command, { noremap = true, silent = true })
	end
	for _, mapping in ipairs(normal_mode_keybinds) do
		M.map("n", mapping.shortcut, mapping.command, { noremap = true, silent = true })
	end
	for _, mapping in ipairs(insert_mode_keybinds) do
		M.map("i", mapping.shortcut, mapping.command, { noremap = true, silent = true })
	end

	if tmux_navigator_available() then
		-- Unmap QWERTY bindings for tmux navigation and set Dvorak bindings
		for _, mapping in ipairs(vim_tmux_keybinds) do
			pcall(vim.keymap.del, "n", mapping.qwerty)
			M.map("n", mapping.dvorak, mapping.command, { noremap = true, silent = true })
		end
	end

	if tmux_navigation_available() then
		-- Unmap QWERTY bindings for nvim-tmux-navigation and set Dvorak bindings
		for _, mapping in ipairs(nvim_tmux_keybinds) do
			pcall(vim.keymap.del, "n", mapping.qwerty)
			M.map("n", mapping.dvorak, mapping.command, { noremap = true, silent = true })
		end
	end

	if smart_splits_available() then
		-- Unmap QWERTY bindings for smart-splits and set Dvorak bindings
		for _, mapping in ipairs(smart_splits_keybinds) do
			pcall(vim.keymap.del, "n", mapping.qwerty)
			M.map("n", mapping.dvorak, mapping.command, { noremap = true, silent = true })
		end
	end

	if M.opts.punctuation_line_navigation then
		for _, mapping in ipairs(punctuation_line_navigation_keybinds) do
			M.map({ "n", "v", "s", "o" }, mapping.shortcut, mapping.command, { noremap = true, silent = true })
		end
	end

	if M.opts.window_management then
		for _, mapping in ipairs(window_management_keybinds) do
			M.map("n", mapping.shortcut, mapping.command, { noremap = true, silent = true })
		end
	end

	if M.opts.leader_buffer_navigation then
		for _, mapping in ipairs(leader_buffer_navigation_keybinds) do
			pcall(vim.keymap.del, "n", mapping.qwerty)
			M.map("n", mapping.dvorak, mapping.command, { noremap = true, silent = true })
		end
	end
end

M.enable = function()
	if M.enabled then
		M.apply_all_mappings()
		return
	end

	M.enabled = true
	vim.g.dvorak_enabled = true
	M.apply_all_mappings()
	print("Dvorak keybinds enabled")
end

M.disable = function()
	if not M.enabled then
		return
	end

	M.restore_maps()
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

function M.setup(opts)
	local defaults = {
		visual_line_navigation = false,
		punctuation_line_navigation = false,
		window_management = false,
		leader_buffer_navigation = false,
		auto_enable = true,
	}

	M.opts = vim.tbl_deep_extend("force", defaults, opts or {})

	vim.api.nvim_create_user_command("DvorakToggle", function()
		M.toggle()
	end, { desc = "Toggle Dvorak keybinds" })
	vim.api.nvim_create_user_command("DvorakEnable", function()
		M.enable()
	end, { desc = "Enable Dvorak keybinds" })
	vim.api.nvim_create_user_command("DvorakDisable", function()
		M.disable()
	end, { desc = "Disable Dvorak keybinds" })

	-- Capture baseline and (re)apply after all plugins have loaded.
	-- LazyDone fires in lazy.nvim distributions; VimEnter is the fallback.
	-- We guard with _baseline_captured so only the first event wins.
	local function on_plugins_loaded()
		if not M._baseline_captured then
			M.capture_baseline()
		end
		if M.opts.auto_enable then
			-- Reset enabled flag so enable() runs fresh after baseline is ready
			M.enabled = false
			vim.g.dvorak_enabled = false
			M.enable()
		end
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyDone",
		once = true,
		callback = on_plugins_loaded,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			-- Only fire if LazyDone hasn't already handled it
			if not M._baseline_captured then
				on_plugins_loaded()
			end
		end,
	})
end

return M
