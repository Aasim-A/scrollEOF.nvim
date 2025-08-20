scrollEOF.nvim
==============
A simple and lightweight plugin to make scrolloff go past the end of the file. It uses the value of `scrolloff` to determine the amount of blank space to mimic the behaviour of scrolloff.

https://user-images.githubusercontent.com/23695024/216361766-34784d03-d9ae-4510-aee1-1536038c100f.mp4

Getting started
---------------
### Install

Using [lazy](https://github.com/folke/lazy.nvim)
```lua
{
  'Aasim-A/scrollEOF.nvim',
  event = { 'CursorMoved', 'WinScrolled' },
  opts = {},
}
```

Using [packer](https://github.com/wbthomason/packer.nvim):
```lua
use('Aasim-A/scrollEOF.nvim')
```

Using [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'Aasim-A/scrollEOF.nvim'
```

### Setup
#### Quick start
Make sure that you set the `scrolloff` setting then add the following line to your Neovim config:

Lua:
```lua
require('scrollEOF').setup()
```
Vimscript:
```vim
lua require('scrollEOF').setup()
```
#### Settings
These are the default settings. Any changes can be made in the call to `setup`.
```lua
-- Default settings
require('scrollEOF').setup({
  -- The pattern used for the internal autocmd to determine
  -- where to run scrollEOF. See https://neovim.io/doc/user/autocmd.html#autocmd-pattern
  pattern = '*',
  -- Whether or not scrollEOF should be enabled in insert mode
  insert_mode = false,
  -- Whether or not scrollEOF should be enabled in floating windows
  floating = true,
  -- List of filetypes to disable scrollEOF for.
  disabled_filetypes = { 'terminal' },
  -- List of modes to disable scrollEOF for. see https://neovim.io/doc/user/builtin.html#mode()
  disabled_modes = { 't', 'nt' },
})
```

> [!NOTE]  
> When using large `scrolloff` values i.e. larger than half of the number of lines on the screen, this plugin will override the `scrolloff` value to be half of the screen lines to avoid conflict from vim trying to prevent scrolloff when reaching end of file.
