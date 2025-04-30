-- Main module for the Hello World plugin
local M = {}

M.diagwin = nil

-- Function to print the hello message
function M.say_hello()
  print 'Hello from Neovim!'
end

function get_cursor_relative_position(cursor)
  local cursor_row = vim.fn.win_screenpos(0)[1] + vim.fn.screenpos(0, unpack(vim.api.nvim_win_get_cursor(0))).row - 1
  local cursor_col = vim.fn.screenpos(0, unpack(vim.api.nvim_win_get_cursor(0))).col
  return { cursor_row, cursor_col }
end

local function distance_to_box(x0, y0, width, height, x, y)
  local x1, y1 = x0 + width, y0 + height
  local dx = math.max(x0 - x, 0, x - x1)
  local dy = math.max(y0 - y, 0, y - y1)
  return dx + dy
end

local function has_window_near_cursor(threshold)
  local cursor = get_cursor_relative_position()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    if config.zindex then
      local pos = vim.api.nvim_win_get_position(win)
      local row, col = pos[1], pos[2]
      local width, height = vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win)
      -- print(win, config.relative, pos[1], cursor[1], pos[2], cursor[2], distance_to_box(row, col, width, height, cursor[1], cursor[2]))
      return distance_to_box(row, col, width, height, cursor[1], cursor[2]) < threshold
    end
  end
  return false
end

-- Function to set up the plugin (Most package managers expect the plugin to have a setup function)
function M.setup(opts)
  -- Function to check if a floating dialog exists and if not
  -- then check for diagnostics under the cursor
  local threshold = opts.win_dist_threshold or 4
  function OpenDiagnosticIfNoFloat()
    if has_window_near_cursor(threshold) then
      return
    end
    -- THIS IS FOR BUILTIN LSP
    vim.diagnostic.open_float {
      scope = 'cursor',
      focusable = false,
      severity_sort = true,
      source = true,
      border = 'single',
      callback = function(_, winid)
        M.diagwin = winid
      end,
    }
  end

  local close_events = {
    'CursorMoved',
    'CursorMovedI',
    'BufHidden',
    'InsertCharPre',
    'WinLeave',
    'WinScrolled',
    'WinNew',
    'MenuPopup',
  }
  -- Show diagnostics under the cursor when holding position
  vim.api.nvim_create_augroup('lsp_diagnostics_hold', { clear = true })
  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    pattern = '*',
    command = 'lua vim.defer_fn(OpenDiagnosticIfNoFloat, 200)',
    group = 'lsp_diagnostics_hold',
  })
  vim.api.nvim_create_autocmd(close_events, {
    callback = function()
      if M.diagwin and vim.api.nvim_win_is_valid(M.diag_win) then
        vim.api.nvim_win_close(M.diag_win, true)
        M.diag_win = nil
      end
    end,
  })
end

-- Return the module
return M
