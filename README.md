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
| Top of screen | `H` | `H` |
| Navigate to window left | `<C-w>h` | `<C-w>h` |
| Navigate to window down | `<C-w>t` | `<C-w>j` |
| Navigate to window up | `<C-w>n` | `<C-w>k` |
| Navigate to window right | `<C-w>s` | `<C-w>l` |
| Navigate next buffer** | `<leader>s` | `<leader>l` |
| Navigate previous buffer** | `<leader>h` | `<leader>h` |

*These are only available if `punctuation_line_navigation` is set to `true` in the plugin's
configuration.  
**These are only available if `leader_buffer_navigation` is set to `true` in the plugin's
configuration.

### Insert mode

| Action | Dvorak | QWERTY |
| ------ | ------ | ------ |
| Move cursor left | `<C-h>` | `<C-h>` |
| Move cursor down | `<C-t>` | `<C-j>` |
| Move cursor up | `<C-n>` | `<C-k>` |
| Move cursor right | `<C-s>` | `<C-l>` |

### Commands

The following commands are available:

- `:DvorakToggle`: Toggles the keybinds on and off.
- `:DvorakEnable`: Enables the keybinds.
- `:DvorakDisable`: Disables the keybinds.

## Plugins

The following plugins are supported:

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
        -- Ensure these plugins are loaded first, if they are installed
        { "christoomey/vim-tmux-navigator", optional = true },
        { "alexghergh/nvim-tmux-navigation", optional = true },
        { "mrjones2014/smart-splits.nvim", optional = true }
    },
    opts = {
        -- Enable the _/- for start/end of line navigation, disabled by default
        punctuation_line_navigation = true,
        -- Use the <leader>h/l/s buffer navigation keybinds, disabled by default
        leader_buffer_navigation = true
        -- Enable the keybinds automatically, enabled by default
        auto_enable = true,
    }
}
```

Suggestions and PRs are welcome.

