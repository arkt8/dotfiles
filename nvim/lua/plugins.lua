local rpath = ","..vim.env.HOME.."/%s"

vim.o.runtimepath =
  vim.o.runtimepath
  .. rpath:format(".config/nvim/ide")
  .. rpath:format(".local/share/nvim/packer.nvim")


return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"


  --///////////////////////////////////////////////////////
  -- Language specifics

  use { "neovimhaskell/haskell-vim"
      , as = "lang-haskell"
      , ft = {"haskell"} }
  use { "vim-python/python-syntax"
      , as = "lang-python"
      , ft = {"python"} }
  use { 'plasticboy/vim-markdown'
      , ft = {"lang-markdown","md"} }
  use { "chr4/nginx.vim" -- Nginx + Lua blocks
      , as = "lang-nginx"
      , ft = {"nginx"} }
  use { "arzg/vim-sh"
      , as = "lang-shellscript"
      , ft = {"zsh", "bash", "sh", "shell"} }
  use { "mrk21/yaml-vim"
      , as = "lang-yaml", ft = {"yaml"} }

  --///////////////////////////////////////////////////////
  -- Tools

  use { "nvim-telescope/telescope.nvim"
      , as = "tool-telescope" }
  use { "nvim-lua/plenary.nvim"
      , as = "tool-plenary" }
  require('plugconf.telescope')

  --///////////////////////////////////////////////////////
  -- UX

  use { "junegunn/limelight.vim"
      , as = "ux-markdown-limelight"
      , ft = {"markdown", "md"} }
  use { "junegunn/fzf", disable= true}


  --///////////////////////////////////////////////////////
  -- Parsers

  use { "neoclide/coc.nvim"
      , as = "parser-lsp"
      , branch = "release" }
  use { "nvim-treesitter/nvim-treesitter"
      , as = "parser-treesitter"
      , run = ":TSUpdate" }

end)


