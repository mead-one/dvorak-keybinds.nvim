# dvorak-keybinds.nvim

This Neovim plugin provides a simple set of keybinds optimised for the Dvorak keyboard layout.

I aim to add support for as many plugins as is practical but any plugin-related keybinds are
currently commented out until checking for loaded plugins is supported. Pull requests welcome!

## Installation
**Lazy**:
```lua
{
"cjm-1/dvorak-keybinds.nvim",
config = function()
  require('dvorak-plugins').setup()
end
}
```

The Dvorak keybinds can be toggled with `:DvorakToggle`.
