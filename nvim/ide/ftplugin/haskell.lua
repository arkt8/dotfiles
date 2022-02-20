vim.g.neoformat_haskell_brittany = {
   exe       = "brittany",
   replace   = 0,
   stdin     = 1,
   no_append = 1
}

vim.g.neoformat_enabled_haskell = { "brittany" }
vim.b.neoformat_try_formatprg = 1
