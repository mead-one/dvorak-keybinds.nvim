-- vim:ts=2:shiftwidth=2:expandtab:cc=81:
-- Keybinds chosen specifically for Dvorak-GB keymap

local M = {}

local global_keybinds = {
  -- (t) Navigate down (display lines - same line if wrapped text)
  { shortcut = "t", command = "j" },
  -- (n) Navigate up (display lines - same line if wrapped text)
  { shortcut = "n", command = "k" },
  -- (s) Navigate right (h) Navigate left
  { shortcut = "s", command = "l" },
  -- (h) remains the same
}

-- Keybinds for normal mode
local normal_mode_keybinds = {
  -- (j) Next search result
  { shortcut = "j", command = "n" },
  -- (J) Previous search result
  { shortcut = "J", command = "N" },
  -- (S) Bottom of screen (H) Top of screen
  { shortcut = "S", command = "L" },
  -- (Ctrl+w d) Navigate to window left
  { shortcut = "<C-w>h", command = "<cmd>wincmd h<CR>" },
  -- (Ctrl+w h) Navigate to window down
  { shortcut = "<C-w>t", command = "<cmd>wincmd j<CR>" },
  -- (Ctrl+w t) Navigate to window up
  { shortcut = "<C-w>n", command = "<cmd>wincmd k<CR>" },
  -- (Ctrl+w n) Navigate to window right
  { shortcut = "<C-w>s", command = "<cmd>wincmd l<CR>" },
}

-- Keybinds for insert mode
local insert_mode_keybinds = {
  -- (Ctrl+d) Move cursor left
  { shortcut = "<C-h>", command = "<Left>" },
  -- (Ctrl+h) Move cursor down
  { shortcut = "<C-t>", command = "<Down>" },
  -- (Ctrl+t) Move cursor up
  { shortcut = "<C-n>", command = "<Up>" },
  -- (Ctrl+n) Move cursor right
  { shortcut = "<C-s>", command = "<Right>" }
}

-- Optional keybinds for punctuation line navigation
local punctuation_line_navigation_keybinds = {
  -- (-) End of line
  { shortcut = "-", command = "$" },
  -- (_) Start of line
  { shortcut = "_", command = "^" },
}

-- Optional keybinds for buffer navigation using the leader key
local leader_buffer_navigation_keybinds = {
  { dvorak = "<leader>h", qwerty = "<leader>h", command = "<cmd>bp<CR>" },
  { dvorak = "<leader>s", qwerty = "<leader>l", command = "<cmd>bn<CR>" }
}

-- Dvorak keybinds for vim-tmux-navigator
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

-- Keybinds for nvim-tmux-navigation
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

-- Keybinds for smart-splits
local smart_splits_keybinds = {
  -- (Ctrl+t) Move cursor down
  { dvorak = "<C-t>", qwerty = "<C-j>", command = "<cmd>lua require('smart-splits').move_cursor_down()<CR>" },
  -- (Ctrl+n) Move cursor up
  { dvorak = "<C-n>", qwerty = "<C-k>", command = "<cmd>lua require('smart-splits').move_cursor_up()<CR>" },
  -- (Ctrl+s) Move cursor right, (Ctrl+h) Move cursor left
  { dvorak = "<C-s>", qwerty = "<C-l>", command = "<cmd>lua require('smart-splits').move_cursor_right()<CR>" },
  -- (Ctrl+t) Resize vertical down
  { dvorak = "<A-t>", qwerty = "<A-j>", command = "<cmd>lua require('smart-splits').resize_down()<CR>" },
  -- (Ctrl+n) Resize vertical up
  { dvorak = "<A-n>", qwerty = "<A-k>", command = "<cmd>lua require('smart-splits').resize_up()<CR>" },
  -- (Ctrl+l) Resize horizontal right, (Ctrl+h) Resize horizontal left
  { dvorak = "<A-s>", qwerty = "<A-l>", command = "<cmd>lua require('smart-splits').resize_right()<CR>" }
}

-- Check if christoomey/vim-tmux-navigator is installed
local function tmux_navigator_available()
  return vim.g.loaded_tmux_navigator == 1 or vim.fn.exists(":TmuxNavigateLeft") > 0
end

-- Check if alexghergh/nvim-tmux-navigation is installed
local function tmux_navigation_available()
  local ok, _ = pcall(require, "nvim-tmux-navigation")
  return ok
end

-- Check if mrjones2014/smart-splits.nvim is installed
local function smart_splits_available()
  local ok, _ = pcall(require, "smart-splits")
  return ok
end

function M.enable()
  if vim.g.dvorak_enabled and vim.g.dvorak_enabled == true then
    return
  end
  -- Set global dvorak keybinds
  for _, mapping in ipairs(global_keybinds) do
    vim.keymap.set("", mapping.shortcut, mapping.command, {noremap = true, silent = true})
  end
  -- Set keybinds for normal mode
  for _, mapping in ipairs(normal_mode_keybinds) do
    vim.keymap.set("n", mapping.shortcut, mapping.command, {noremap = true, silent = true})
  end
  -- Set keybinds for insert mode
  for _, mapping in ipairs(insert_mode_keybinds) do
    vim.keymap.set("i", mapping.shortcut, mapping.command, {noremap = true, silent = true})
  end

  if tmux_navigator_available() then
    -- Unmap QWERTY bindings for tmux navigation and set Dvorak bindings
    for _, mapping in ipairs(vim_tmux_keybinds) do
      pcall(vim.keymap.del, "n", mapping.qwerty)
      vim.keymap.set("n", mapping.dvorak, mapping.command, {noremap = true, silent = true})
    end
  end

  if tmux_navigation_available() then
    -- Unmap QWERTY bindings for nvim-tmux-navigation and set Dvorak bindings
    for _, mapping in ipairs(nvim_tmux_keybinds) do
      pcall(vim.keymap.del, "n", mapping.qwerty)
      vim.keymap.set("n", mapping.dvorak, mapping.command, {noremap = true, silent = true})
    end
  end

  if smart_splits_available() then
    -- Unmap QWERTY bindings for smart-splits and set Dvorak bindings
    for _, mapping in ipairs(smart_splits_keybinds) do
      pcall(vim.keymap.del, "n", mapping.qwerty)
      vim.keymap.set("n", mapping.shortcut, mapping.dvorak, {noremap = true, silent = true})
    end
  end

  if vim.g.dvorak_punctuation_line_navigation then
    for _, mapping in ipairs(punctuation_line_navigation_keybinds) do
      vim.keymap.set("n", mapping.shortcut, mapping.command, {noremap = true, silent = true})
    end
  end

  if vim.g.dvorak_leader_buffer_navigation then
    for _, mapping in ipairs(leader_buffer_navigation_keybinds) do
      pcall(vim.keymap.del, "n", mapping.qwerty)
      vim.keymap.set("n", mapping.dvorak, mapping.command, {noremap = true, silent = true})
    end
  end

  vim.g.dvorak_enabled = true
  print("Dvorak keybinds enabled")
end

function M.disable()
  if vim.g.dvorak_enabled and vim.g.dvorak_enabled == false then
    return
  end

  -- Unmap global dvorak keybinds
  for _, mapping in ipairs(global_keybinds) do
    pcall(vim.keymap.del, "", mapping.shortcut)
  end

  -- Unmap dvorak bindings for normal mode
  for _, mapping in ipairs(normal_mode_keybinds) do
    pcall(vim.keymap.del, "n", mapping.shortcut)
  end

  -- Unmap dvorak bindings for insert mode
  for _, mapping in ipairs(insert_mode_keybinds) do
    pcall(vim.keymap.del, "i", mapping.shortcut)
  end

  -- Unmap Dvorak keybinds for tmux navigation and set QWERTY bindings
  if tmux_navigator_available() then
    for _, mapping in ipairs(vim_tmux_keybinds) do
      pcall(vim.keymap.del, "n", mapping.dvorak)
      vim.keymap.set("n", mapping.qwerty, mapping.command, {noremap = true, silent = true})
    end
  end

  if tmux_navigation_available() then
    -- Unmap Dvorak keybinds for nvim-tmux-navigation
    for _, mapping in ipairs(nvim_tmux_keybinds) do
      pcall(vim.keymap.del, "n", mapping.dvorak)
      vim.keymap.set("n", mapping.qwerty, mapping.command, {noremap = true, silent = true})
    end
  end

  if smart_splits_available() then
    -- Unmap Dvorak keybinds for smart-splits
    for _, mapping in pairs(smart_splits_keybinds) do
      pcall(vim.keymap.del, "n", mapping.dvorak)
      vim.keymap.set("n", mapping.qwerty, mapping.command, {noremap = true, silent = true})
    end
  end

  if vim.g.dvorak_punctuation_line_navigation then
    for _, mapping in ipairs(punctuation_line_navigation_keybinds) do
      pcall(vim.keymap.del, "n", mapping.shortcut)
    end
  end

  if vim.g.dvorak_leader_buffer_navigation then
    for _, mapping in ipairs(leader_buffer_navigation_keybinds) do
      pcall(vim.keymap.del, "n", mapping.dvorak)
      vim.keymap.set("n", mapping.qwerty, mapping.command, {noremap = true, silent = true})
    end
  end

  vim.g.dvorak_enabled = false
  print("Dvorak keybinds disabled")
end

-- Toggle Dvorak keybinds on and off
function M.toggle()
  if vim.g.dvorak_enabled and vim.g.dvorak_enabled == true then
    M.disable()
  else
    M.enable()
  end
end

function M.setup(opts)
  local defaults = {
    punctuation_line_navigation = false,
    leader_buffer_navigation = false,
    auto_enable = true,
  }

  opts = vim.tbl_deep_extend("force", defaults, opts or {})

  vim.g.dvorak_punctuation_line_navigation = opts.punctuation_line_navigation
  vim.g.dvorak_leader_buffer_navigation = opts.leader_buffer_navigation

  vim.api.nvim_create_user_command("DvorakToggle", function()
    M.toggle()
  end, { desc = "Toggle Dvorak keybinds" })

  vim.api.nvim_create_user_command("DvorakEnable", function()
    M.enable()
  end, { desc = "Enable Dvorak keybinds" })

  vim.api.nvim_create_user_command("DvorakDisable", function()
    M.disable()
  end, { desc = "Disable Dvorak keybinds" })

  if opts.auto_enable then
    M.enable()
  end
end

return M

