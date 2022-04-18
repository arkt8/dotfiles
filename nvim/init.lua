package.path= vim.env.HOME..'/.config/nvim/ide/lua/?.lua'
     ..';/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;'
     ..package.path
package.cpath=package.cpath..';/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;/usr/lib/lua/5.1/?.so'

vim.g.mapleader = "\\"
vim.g.netrw_banner = 0

do local _ = vim.opt

_.mouse="a"

-- Search configuration
_.hlsearch   = true
_.ignorecase = true
_.incsearch  = true
_.smartcase  = true

-- Indentation
_.autoindent     = true
_.expandtab      = true
_.shiftwidth     = 4     -- columns used on softwidth
_.smartindent    = true
_.softtabstop    = 4

-- Appearance
_.background     = dark
_.colorcolumn    = "0"
_.cursorline     = false
_.foldenable     = false
_.relativenumber = false
_.numberwidth    = 2     -- use <,l> to toggle display line number
_.number         = true
_.ruler          = true  -- Show line number and column number on status line
_.hlsearch       = true  -- Hilight search matched
_.list = true 
_.listchars:append{
  tab      = "│ ", -- Used by Tab on expandtab=false
  trail    = "*",  -- Spaces at the end of line
  precedes = "«",  -- Ellipsis at the left of screen
  extends  = "»"   -- Ellipsis at the right ot screen
}

_.modelineexpr   = true
_.swapfile       = false
_.backup         = false
_.splitbelow     = true
_.splitright     = true
_.tabstop        = 4     -- columns used on tab (default=8)
_.timeoutlen     = 3000
_.wildmenu       = true
_.wrap           = false
_.clipboard      = "unnamedplus"
_.termguicolors  = true
end


if vim.o.diff then
   require('diff')
else
   require('plugins')
   vim.cmd[[colorscheme wal]]
end







