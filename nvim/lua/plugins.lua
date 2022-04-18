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
--[[  use { "alaviss/nim.nvim"
      , as = "lang-nim"
      , ft = {"nim"} } ]]
  use { "neovim/nvim-lspconfig" }
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use { "zah/nim.vim"
      , as = "lang-nim"
      , ft = {"nim"} }
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
  use { "wsdjeg/vim-lua"
      , as = "lang-lua",  ft = {"lua"} }

  --///////////////////////////////////////////////////////
  -- Tools

  use { "nvim-telescope/telescope.nvim"
      , as = "tool-telescope" }
  use { "nvim-lua/plenary.nvim"
      , as = "tool-plenary" }
  use { "sbdchd/neoformat"
      , as = "tool-formatter" }
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
      , branch = "release"
      , config = function()
           --vim.fn['coc#config']('diagnostic',{autoRefresh = false})
           --vim.cmd[[ CocCommand extensions.toggleAutoUpdate ]]
        end
      , ft = {"php","javascript","haskell"}
      , run = function()
         vim.cmd[[ :call Ide_CocConfig() ]]
         vim.cmd[[ autocmd ModeChanged * :call CocActionAsync('diagnosticRefresh') ]]
      end
      }
  use { "nvim-treesitter/nvim-treesitter"
      , as = "parser-treesitter"
      , run = ":TSUpdate" }

  use { "pierreglaser/folding-nvim"
      , as = "parser-folding"
      , run = "require('folding').on_attach()" }

  use { "bluz71/vim-nightfly-guicolors"
      , as = "cs-nighfly" }
  use { "Shatur/neovim-ayu"
      , as = "cs-ayu" }
end)


