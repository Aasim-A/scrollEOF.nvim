scrollEOF.nvim
==============
A simple and lightweight plugin to make scrolloff go past the end of the file. It uses the value of `scrolloff` to determine the amount of blank space to mimic the behaviour of scrolloff.

[Demo](https://user-images.githubusercontent.com/23695024/216339798-d4d96286-937a-40ca-8228-715e6e549296.mp4)

Getting started
---------------
### Install

Using [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'Aasim-A/scrollEOF.nvim'
```
Using [packer](https://github.com/wbthomason/packer.nvim):
```lua
use('Aasim-A/scrollEOF.nvim')
```

### Setup
#### Quick start
Add the following line to your Neovim config

Lua:
```lua
require('scrollEOF').setup({})
```
Vimscript:
```vim
lua require('scrollEOF').setup({})
```
#### Settings
These are the default settings. Any changes can be made in the call to `setup`.
```lua
-- Default settings
require('scrollEOF').setup({
  -- The pattern used for the internal autocmd to determine
  -- where to run scrollEOF. See https://neovim.io/doc/user/autocmd.html#autocmd-pattern
  pattern = '*'
})
```
