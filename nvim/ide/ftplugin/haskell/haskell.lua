local ide = require('ideutils')
ide.bmap('n', "\\-", '<ESC>O<Esc>60i-<ESC>0')

-- For plugin neovimhaskell/haskell-vim
do local b, bo = vim.b, vim.bo
b.haskell_indent_disable=1
b.haskell_enable_quantification = 1   -- hili `forall`
b.haskell_enable_recursivedo = 1      -- hili `mdo` and `rec`
b.haskell_enable_arrowsyntax = 1      -- hili `proc`
b.haskell_enable_pattern_synonyms = 1 -- hili `pattern`
b.haskell_enable_typeroles = 1        -- hili type roles
b.haskell_enable_static_pointers = 1  -- hili `static`
b.haskell_backpack = 1                -- hili backpack keywords

bo.expandtab = true
bo.shiftwidth = 2
bo.softtabstop = 2
bo.tabstop = 2

end
