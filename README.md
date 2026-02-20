# dvorak-keybinds.nvim

This Neovim plugin provides a simple set of keybinds optimised for the Dvorak keyboard layout.

It replaces the traditional `h` `j` `k` `l` movement keys with `h` `t` `n` `s`, which I find
to be a comfortable and natural way to move around in Neovim.

## Keybinds

The following is a comprehensive list of remapped actions, both to fit the Dvorak layout and
to resolve conflicts with other actions:

### Normal mode

| Action | Dvorak | QWERTY |
| ------ | ------ | ------ |
| Move cursor left | `h` | `h` |
| Move cursor down | `t` | `j` |
| Move cursor up | `n` | `k` |
| Move cursor right | `s` | `l` |
| Move cursor to the start of the line* | `_` | `0` |
| Move cursor to the end of the line* | `-` | `$` |
| Next search result | `j` | `n` |
| Previous search result | `J` | `N` |
| Bottom of screen | `S` | `L` |
| Till character | `<leader>t` | `t` |
| Till character backwards | `<leader>T` | `T` |
| Top of screen | `H` | `H` |
| Navigate to window left\*\* | `<C-w>h` | `<C-w>h` |
| Navigate to window down\*\* | `<C-w>t` | `<C-w>j` |
| Navigate to window up\*\* | `<C-w>n` | `<C-w>k` |
| Navigate to window right\*\* | `<C-w>s` | `<C-w>l` |
| Split window horizontally\*\* | `<C-w>z` | `<C-w>s` |
| Navigate next buffer\*\*\* | `<leader>s` | `<leader>l` |
| Navigate previous buffer\*\*\* | `<leader>h` | `<leader>h` |
| flash.nvim jump \*\*\*\* | gz | s |
| flash.nvim treesitter \*\*\*\* | gZ | s |
| flash.nvim toggle \*\*\*\* | \<C-/\> | \<C-s\> |

\* These are only available if `punctuation_line_navigation` is set to `true` in the plugin's
configuration.<br />
\*\* These are only available if `window_management` is set to `true` in the plugin's configuration.<br />
\*\*\* These are only available if `leader_buffer_navigation` is set to `true` in the plugin's
configuration.<br />
\*\*\*\* These are only available if folke/flash.nvim is installed.

### Insert mode

| Action | Dvorak | QWERTY |
| ------ | ------ | ------ |
| Move cursor left | `<C-h>` | `<C-h>` |
| Move cursor down | `<C-t>` | `<C-j>` |
| Move cursor up | `<C-n>` | `<C-k>` |
| Move cursor right | `<C-s>` | `<C-l>` |
| flash.nvim jump * | gz | s |
| flash.nvim treesitter * | gZ | s |
| flash.nvim toggle * | \<C-/\> | \<C-s\> |

\* These are only available if folke/flash.nvim is installed.

### Commands

The following commands are available:

- `:DvorakToggle`: Toggles the keybinds on and off.
- `:DvorakEnable`: Enables the keybinds.
- `:DvorakDisable`: Disables the keybinds.

## Plugins

In my experience so far, this plugin seems to work well with LazyVim, and has an
optional integration to work with Snacks, applying Dvorak-friendly keymaps to its menus.

The following plugins are supported:

- [folke/flash.nvim](https://github.com/folke/flash.nvim)
- [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [alexghergh/nvim-tmux-navigation](https://github.com/alexghergh/nvim-tmux-navigation)
- [mrjones2014/smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)

Note that `christoomey/vim-tmux-navigator` and `alexghergh/nvim-tmux-navigation` are
mutually exclusive, so only one of them can be installed at a time. Also, I no longer
actively use `smart-splits.nvim`, so I haven't covered the case where it and one of the
tmux navigation plugins are both installed.

## Installation
**Lazy**:
```lua
{
    "mead-one/dvorak-keybinds.nvim",
    dependencies = {
      -- Ensure this runs after flash.nvim if it is installed. This plugin will set
      -- appropriate keybinds to replace flash's defaults, as documented in the above
      -- table. No effect if flash is not installed
      { "folke/flash.nvim", optional = true }
    },
    opts = {
        -- Use visual line navigation, disabled by default
        visual_line_navigation = true,
        -- Enable the _/- for start/end of line navigation, disabled by default
        punctuation_line_navigation = true,
        -- Remap the directional Ctrl+w window management commands, disabled by default
        window_management = true,
        -- Use the <leader>h/l/s buffer navigation keybinds, disabled by default
        leader_buffer_navigation = true
        -- Enable the keybinds automatically, enabled by default
        auto_enable = true,
    }
},
-- Apply the optional integration with snacks, if it is installed (optional = true)
{
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
        -- Extend the existing opts with those in the integration
        return require("dvorak-keybinds").integrations.snacks(opts)
    end,
}
```

All suggestions, constructive feedback and PRs are welcome.

