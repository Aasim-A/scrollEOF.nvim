local M = {}

-- Add ability to scroll past end of file
local scroll_key = vim.api.nvim_replace_termcodes('<C-e>', true, true, true)
local function check_eof_scrolloff()
  local win_height = vim.api.nvim_win_get_height(0)
  local scrolloff = vim.o.scrolloff
  if scrolloff > win_height / 2 then
    scrolloff = math.floor(win_height / 2)
  end

  local last_line = vim.fn.line('$')
  local visible_first_line = vim.fn.line('w0')
  local visible_last_line = vim.fn.line('w$')
  local current_line = vim.fn.line('.')
  local scrolloff_line_count = win_height - (visible_last_line - visible_first_line + 1)
  local distance_to_last_line = last_line - current_line

  if distance_to_last_line < scrolloff and scrolloff_line_count + distance_to_last_line < scrolloff then
    local repeatCount = scrolloff - (scrolloff_line_count + distance_to_last_line)
    vim.api.nvim_feedkeys(repeatCount .. scroll_key, 'n', false)
  end
end

M.setup = function(opts)
  local default_opts = {
    pattern = '*',
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


  local scrolloff_group = vim.api.nvim_create_augroup('ScrollEOF', { clear = true })
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = scrolloff_group,
    pattern = opts.pattern,
    callback = check_eof_scrolloff,
  })
end

return M
