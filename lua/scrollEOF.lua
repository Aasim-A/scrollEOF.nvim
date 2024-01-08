local M = {}

local mode_disabled = false
local filetype_disabled = false

local function check_eof_scrolloff()
  if mode_disabled or filetype_disabled then
    return
  end

  local win_height = vim.fn.winheight(0)
  local win_cur_line = vim.fn.winline()
  local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
  local visual_distance_to_eof = win_height - win_cur_line

  if visual_distance_to_eof < scrolloff then
    local win_view = vim.fn.winsaveview()
    vim.fn.winrestview({ topline = win_view.topline + scrolloff - visual_distance_to_eof })
  end
end

M.setup = function(opts)
  local default_opts = {
    pattern = '*',
    insert_mode = false,
    disabled_filetypes = {},
    disabled_modes = {},
  }

  if opts == nil then
    opts = default_opts
  else
    for key, value in pairs(default_opts) do
      if opts[key] == nil then
        opts[key] = value
      end
    end
  end

  local disabled_filetypes_hashmap = {}
  for _, val in pairs(opts.disabled_filetypes) do
    disabled_filetypes_hashmap[val] = true
  end
  opts.disabled_filetypes = disabled_filetypes_hashmap

  local disabled_modes_hashmap = {}
  for _, val in pairs(opts.disabled_modes) do
    disabled_modes_hashmap[val] = true
  end
  opts.disabled_modes = disabled_modes_hashmap

  local autocmds = { 'CursorMoved', 'WinScrolled' }
  if opts.insert_mode then
    table.insert(autocmds, 'CursorMovedI')
  end

  local scrollEOF_group = vim.api.nvim_create_augroup('ScrollEOF', { clear = true })
  vim.api.nvim_create_autocmd('BufEnter', {
    group = scrollEOF_group,
    pattern = opts.pattern,
    callback = function()
      filetype_disabled = opts.disabled_filetypes[vim.o.filetype] == true
    end,
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = scrollEOF_group,
    pattern = opts.pattern,
    callback = function()
      mode_disabled = opts.disabled_modes[vim.api.nvim_get_mode().mode] == true
    end,
  })

  vim.api.nvim_create_autocmd(autocmds, {
    group = scrollEOF_group,
    pattern = opts.pattern,
    callback = check_eof_scrolloff,
  })
end

return M
