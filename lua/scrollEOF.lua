local M = {}

local function check_eof_scrolloff()
  local win_height = vim.api.nvim_win_get_height(0)
  local win_view = vim.fn.winsaveview()
  local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
  local scrolloff_line_count = win_height - (vim.fn.line('w$') - win_view.topline + 1)
  local distance_to_last_line = vim.fn.line('$') - win_view.lnum

  if distance_to_last_line < scrolloff and scrolloff_line_count + distance_to_last_line < scrolloff then
    win_view.topline = win_view.topline + scrolloff - (scrolloff_line_count + distance_to_last_line)
    vim.fn.winrestview(win_view)
  end
end

M.setup = function(opts)
  local default_opts = {
    pattern = '*',
    insert_mode = false,
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

  local autocmds = { 'CursorMoved' }
  if opts.insert_mode then
    table.insert(autocmds, 'CursorMovedI')
  end

  vim.api.nvim_create_autocmd(autocmds, {
    group = vim.api.nvim_create_augroup('ScrollEOF', { clear = true }),
    pattern = opts.pattern,
    callback = check_eof_scrolloff,
  })
end

return M
