local M = {}

M.path = vim.fn.expand('<sfile>:p:h:h')

function M.bmap(mode,lhs,rhs)
   vim.api.nvim_buf_set_keymap(
      0, mode, lhs, rhs,
      { nowait = true
      , noremap = true
      , silent = true }
   )
end

function M.map(mode, lhs, rhs, opts)
   vim.api.nvim_set_keymap(
      mode, lhs, rhs,
      { nowait = true
      , noremap = true
      , silent = true }
   )
end

return M
