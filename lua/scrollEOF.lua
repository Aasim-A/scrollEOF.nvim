local M = {}

local mode_disabled = false
local filetype_disabled = false

local function check_eof_scrolloff()
  if mode_disabled or filetype_disabled then
    return
  end

  local win_height = vim.api.nvim_win_get_height(0)
  local win_view = vim.fn.winsaveview()
  local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
  local cur_line = win_view.lnum
  local last_line = vim.fn.line('$')

  -- determine the number of folded lines between cursorline and end of file
  local folded_lines = 0
  local next_fold_end_ln = -1
  for ln = cur_line, last_line, 1 do
    if ln > next_fold_end_ln then -- skip folded lines we already added to the count
      next_fold_end_ln = vim.fn.foldclosedend(ln)
      local is_folded_line = next_fold_end_ln ~= -1
      if is_folded_line then
        local fold_size = next_fold_end_ln - ln
        folded_lines = folded_lines + fold_size
      end
    end
  end

  local last_line_in_win = vim.fn.line('w$') - folded_lines
  local distance_to_last_line = last_line - cur_line - folded_lines
  local scrolloff_line_count = win_height - (last_line_in_win - win_view.topline + 1)

  if distance_to_last_line < scrolloff and scrolloff_line_count + distance_to_last_line < scrolloff then
    win_view.topline = win_view.topline + scrolloff - (scrolloff_line_count + distance_to_last_line)
    vim.fn.winrestview(win_view)
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

  local autocmds = { 'CursorMoved' }
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
