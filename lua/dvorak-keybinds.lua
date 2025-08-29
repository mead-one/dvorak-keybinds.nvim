-- vim:ts=2:shiftwidth=2:expandtab:cc=81:
-- Keybinds chosen specifically for Dvorak-GB keymap

local M = {}

local global_keybinds = {
  -- (t) Navigate down (display lines - same line if wrapped text)
  {shortcut = "t", command = "j"},
  -- (n) Navigate up (display lines - same line if wrapped text)
  {shortcut = "n", command = "k"},
  -- (s) Navigate right (h) Navigate left
  {shortcut = "s", command = "l"},
  -- (h) remains the same
  -- (-) End of line
  {shortcut = "-", command = "$"},
  -- (_) Start of line
  {shortcut = "_", command = "^"},
}

-- Keybinds for normal mode
local normal_mode_keybinds = {
  -- (j) Next search result
  {shortcut = "j", command = "n"},
  -- (J) Previous search result
  {shortcut = "J", command = "N"},
  -- (S) Bottom of screen (H) Top of screen
  {shortcut = "S", command = "L"},
  -- (Ctrl+w d) Navigate to window left
  {shortcut = "<C-w>h", command = "<cmd>wincmd h<CR>"},
  -- (Ctrl+w h) Navigate to window down
  {shortcut = "<C-w>t", command = "<cmd>wincmd j<CR>"},
  -- (Ctrl+w t) Navigate to window up
  {shortcut = "<C-w>n", command = "<cmd>wincmd k<CR>"},
  -- (Ctrl+w n) Navigate to window right
  {shortcut = "<C-w>s", command = "<cmd>wincmd l<CR>"},
}

-- Keybinds for insert mode
local insert_mode_keybinds = {
  -- (Ctrl+d) Move cursor left
  {shortcut = "<C-h>", command = "<Left>"},
  -- (Ctrl+h) Move cursor down
  {shortcut = "<C-t>", command = "<Down>"},
  -- (Ctrl+t) Move cursor up
  {shortcut = "<C-n>", command = "<Up>"},
  -- (Ctrl+n) Move cursor right
  {shortcut = "<C-s>", command = "<Right>"}
}

-- QWERTY keybinds for vim-tmux-navigator
local vim_tmux_keybinds_qwerty = {
  -- (Ctrl+h) Focus window left
  {shortcut = "<C-h>", command = "<cmd>TmuxNavigateLeft<CR>"},
  -- (Ctrl+j) Focus window below
  {shortcut = "<C-j>", command = "<cmd>TmuxNavigateDown<CR>"},
  -- (Ctrl+k) Focus window above
  {shortcut = "<C-k>", command = "<cmd>TmuxNavigateUp<CR>"},
  -- (Ctrl+l) Focus window right
  {shortcut = "<C-l>", command = "<cmd>TmuxNavigateRight<CR>"},
}

-- Dvorak keybinds for vim-tmux-navigator
local vim_tmux_keybinds_dvorak = {
  -- (Ctrl+h) Focus window left
  {shortcut = "<C-h>", command = "<cmd>TmuxNavigateLeft<CR>"},
  -- (Ctrl+t) Focus window below
  {shortcut = "<C-t>", command = "<cmd>TmuxNavigateDown<CR>"},
  -- (Ctrl+n) Focus window above
  {shortcut = "<C-n>", command = "<cmd>TmuxNavigateUp<CR>"},
  -- (Ctrl+s) Focus window right
  {shortcut = "<C-s>", command = "<cmd>TmuxNavigateRight<CR>"},
}

-- QWERTY keybinds for nvim-tmux-navigation
local nvim_tmux_keybinds_qwerty = {
  -- (Ctrl+h) Focus window left
  {shortcut = "<C-h>", command = "<cmd>NvimTmuxNavigateLeft<CR>"},
  -- (Ctrl+j) Focus window below
  {shortcut = "<C-j>", command = "<cmd>NvimTmuxNavigateDown<CR>"},
  -- (Ctrl+k) Focus window above
  {shortcut = "<C-k>", command = "<cmd>NvimTmuxNavigateUp<CR>"},
  -- (Ctrl+l) Focus window right
  {shortcut = "<C-l>", command = "<cmd>NvimTmuxNavigateRight<CR>"},
}

-- Dvorak keybinds for nvim-tmux-navigation
local nvim_tmux_keybinds_dvorak = {
  -- (Ctrl+h) Focus window left
  {shortcut = "<C-h>", command = "<cmd>NvimTmuxNavigateLeft<CR>"},
  -- (Ctrl+t) Focus window below
  {shortcut = "<C-t>", command = "<cmd>NvimTmuxNavigateDown<CR>"},
  -- (Ctrl+n) Focus window above
  {shortcut = "<C-n>", command = "<cmd>NvimTmuxNavigateUp<CR>"},
  -- (Ctrl+s) Focus window right
  {shortcut = "<C-s>", command = "<cmd>NvimTmuxNavigateRight<CR>"},
}

-- Qwerty keybinds for smart-splits
local smart_splits_keybinds_qwerty = {
  -- (Ctrl+j) Move cursor down
  {shortcut = "<C-j>", command = "<cmd>lua require(\"smart-splits\").move_cursor_down()<CR>"},
  -- (Ctrl+k) Move cursor up
  {shortcut = "<C-k>", command = "<cmd>lua require(\"smart-splits\").move_cursor_up()<CR>"},
  -- (Ctrl+l) Move cursor right, (Ctrl+h) Move cursor left
  {shortcut = "<C-l>", command = "<cmd>lua require(\"smart-splits\").move_cursor_right()<CR>"},
  -- (Ctrl+j) Resize vertical down
  {shortcut = "<A-j>", command = "<cmd>lua require(\"smart-splits\").resize_down()<CR>"},
  -- (Ctrl+k) Resize vertical up
  {shortcut = "<A-k>", command = "<cmd>lua require(\"smart-splits\").resize_up()<CR>"},
  -- (Ctrl+l) Resize horizontal right, (Ctrl+h) Resize horizontal left
  {shortcut = "<A-l>", command = "<cmd>lua require(\"smart-splits\").resize_right()<CR>"},
}

-- Dvorak keybinds for smart-splits
local smart_splits_keybinds_dvorak = {
  -- (Ctrl+t) Move cursor down
  {shortcut = "<C-t>", command = "<cmd>lua require('smart-splits').move_cursor_down()<CR>"},
  -- (Ctrl+n) Move cursor up
  {shortcut = "<C-n>", command = "<cmd>lua require('smart-splits').move_cursor_up()<CR>"},
  -- (Ctrl+s) Move cursor right, (Ctrl+h) Move cursor left
  {shortcut = "<C-s>", command = "<cmd>lua require('smart-splits').move_cursor_right()<CR>"},
  -- (Ctrl+t) Resize vertical down
  {shortcut = "<A-t>", command = "<cmd>lua require('smart-splits').resize_down()<CR>"},
  -- (Ctrl+n) Resize vertical up
  {shortcut = "<A-n>", command = "<cmd>lua require('smart-splits').resize_up()<CR>"},
  -- (Ctrl+l) Resize horizontal right, (Ctrl+h) Resize horizontal left
  {shortcut = "<A-s>", command = "<cmd>lua require('smart-splits').resize_right()<CR>"}
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
    -- Unmap QWERTY bindings for tmux navigation
    for _, mapping in ipairs(vim_tmux_keybinds_qwerty) do
      pcall(vim.keymap.del, "n", mapping.shortcut)
    end
    -- Re-map Dvorak bindings for tmux navigation
    for _, mapping in ipairs(vim_tmux_keybinds_dvorak) do
      vim.keymap.set("n", mapping.shortcut, mapping.command, {noremap = true, silent = true})
    end
  end

  if tmux_navigation_available() then
    -- Unmap QWERTY bindings for nvim-tmux-navigation
    for _, mapping in ipairs(nvim_tmux_keybinds_qwerty) do
      pcall(vim.keymap.del, "n", mapping.shortcut)
    end

    -- Re-map Dvorak bindings for nvim-tmux-navigation
    for _, mapping in ipairs(nvim_tmux_keybinds_dvorak) do
      vim.keymap.set("n", mapping.shortcut, mapping.command, {noremap = true, silent = true})
    end
  end

  if smart_splits_available() then
    -- Unmap QWERTY bindings for smart-splits
    for _, mapping in ipairs(smart_splits_keybinds_qwerty) do
      pcall(vim.keymap.del, "n", mapping.shortcut)
    end
    -- Set keybinds for smart-splits
    for _, mapping in ipairs(smart_splits_keybinds_dvorak) do
      vim.keymap.set("n", mapping.shortcut, mapping.command, {noremap = true, silent = true})
    end
  end

  if vim.g.leader_buffer_navigation then
    -- Unmap <leader>l
    pcall(vim.keymap.del, "n", "<leader>l")

    -- Map <leader>s
    vim.keymap.set("n", "<leader>s", "<cmd>bp<CR>", {noremap = true, silent = true})
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

  -- Unmap Dvorak keybinds for tmux navigation
  if tmux_navigator_available() then
    for _, mapping in ipairs(vim_tmux_keybinds_dvorak) do
      pcall(vim.keymap.del, "n", mapping.shortcut)
    end
    -- Re-set QWERTY keybinds for tmux navigation
    for _, mapping in ipairs(vim_tmux_keybinds_qwerty) do
      vim.keymap.set("n", mapping.shortcut, mapping.command, {noremap = true, silent = true})
    end
  end

  if tmux_navigation_available() then
    -- Unmap Dvorak keybinds for nvim-tmux-navigation
    for _, mapping in ipairs(nvim_tmux_keybinds_dvorak) do
      pcall(vim.keymap.del, "n", mapping.shortcut)
    end

    -- Re-set QWERTY keybinds for nvim-tmux-navigation
    for _, mapping in ipairs(nvim_tmux_keybinds_qwerty) do
      vim.keymap.set("n", mapping.shortcut, mapping.command, {noremap = true, silent = true})
    end
  end

  if smart_splits_available() then
    -- Unmap Dvorak keybinds for smart-splits
    for _, mapping in pairs(smart_splits_keybinds_dvorak) do
      pcall(vim.keymap.del, "n", mapping.shortcut)
    end
    -- Re-set QWERTY keybinds for smart-splits
    for _, mapping in pairs(smart_splits_keybinds_qwerty) do
      vim.keymap.set("n", mapping.shortcut, mapping.command, {noremap = true, silent = true})
    end
  end

  if vim.g.leader_buffer_navigation then
    -- Unmap <leader>s
    pcall(vim.keymap.del, "n", "<leader>s")

    -- Map <leader>l
    vim.keymap.set("n", "<leader>l", "<cmd>bn<CR>", {noremap = true, silent = true})
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
  opts = opts or {}

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

  if opts.leader_buffer_navigation then
    vim.g.leader_buffer_navigation = true
    -- Set <leader>h, which is the same, regardless of keymap
    vim.keymap.set("n", "<leader>h", "<cmd>bp<CR>", {noremap = true, silent = true})
  end
end

return M

