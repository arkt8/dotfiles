-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/thadeu/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/thadeu/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/thadeu/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/thadeu/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/thadeu/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["cs-ayu"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/cs-ayu",
    url = "https://github.com/Shatur/neovim-ayu"
  },
  ["cs-nighfly"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/cs-nighfly",
    url = "https://github.com/bluz71/vim-nightfly-guicolors"
  },
  ["lang-haskell"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-haskell",
    url = "https://github.com/neovimhaskell/haskell-vim"
  },
  ["lang-lua"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-lua",
    url = "https://github.com/wsdjeg/vim-lua"
  },
  ["lang-nginx"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-nginx",
    url = "https://github.com/chr4/nginx.vim"
  },
  ["lang-nim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-nim",
    url = "https://github.com/zah/nim.vim"
  },
  ["lang-python"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-python",
    url = "https://github.com/vim-python/python-syntax"
  },
  ["lang-shellscript"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-shellscript",
    url = "https://github.com/arzg/vim-sh"
  },
  ["lang-yaml"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-yaml",
    url = "https://github.com/mrk21/yaml-vim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["parser-folding"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/parser-folding",
    url = "https://github.com/pierreglaser/folding-nvim"
  },
  ["parser-lsp"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/parser-lsp",
    url = "https://github.com/neoclide/coc.nvim"
  },
  ["parser-treesitter"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/parser-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["tool-formatter"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/tool-formatter",
    url = "https://github.com/sbdchd/neoformat"
  },
  ["tool-plenary"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/tool-plenary",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["tool-telescope"] = {
    loaded = true,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/start/tool-telescope",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["ux-markdown-limelight"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/ux-markdown-limelight",
    url = "https://github.com/junegunn/limelight.vim"
  },
  ["vim-markdown"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/thadeu/.local/share/nvim/site/pack/packer/opt/vim-markdown",
    url = "https://github.com/plasticboy/vim-markdown"
  }
}

time([[Defining packer_plugins]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType zsh ++once lua require("packer.load")({'lang-shellscript'}, { ft = "zsh" }, _G.packer_plugins)]]
vim.cmd [[au FileType bash ++once lua require("packer.load")({'lang-shellscript'}, { ft = "bash" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'lang-lua'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'ux-markdown-limelight'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType yaml ++once lua require("packer.load")({'lang-yaml'}, { ft = "yaml" }, _G.packer_plugins)]]
vim.cmd [[au FileType nim ++once lua require("packer.load")({'lang-nim'}, { ft = "nim" }, _G.packer_plugins)]]
vim.cmd [[au FileType python ++once lua require("packer.load")({'lang-python'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType nginx ++once lua require("packer.load")({'lang-nginx'}, { ft = "nginx" }, _G.packer_plugins)]]
vim.cmd [[au FileType lang-markdown ++once lua require("packer.load")({'vim-markdown'}, { ft = "lang-markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType md ++once lua require("packer.load")({'ux-markdown-limelight', 'vim-markdown'}, { ft = "md" }, _G.packer_plugins)]]
vim.cmd [[au FileType php ++once lua require("packer.load")({'parser-lsp'}, { ft = "php" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'parser-lsp'}, { ft = "javascript" }, _G.packer_plugins)]]
vim.cmd [[au FileType sh ++once lua require("packer.load")({'lang-shellscript'}, { ft = "sh" }, _G.packer_plugins)]]
vim.cmd [[au FileType shell ++once lua require("packer.load")({'lang-shellscript'}, { ft = "shell" }, _G.packer_plugins)]]
vim.cmd [[au FileType haskell ++once lua require("packer.load")({'parser-lsp', 'lang-haskell'}, { ft = "haskell" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/thadeu/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], true)
vim.cmd [[source /home/thadeu/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]]
time([[Sourcing ftdetect script at: /home/thadeu/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], false)
time([[Sourcing ftdetect script at: /home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-nginx/ftdetect/nginx.vim]], true)
vim.cmd [[source /home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-nginx/ftdetect/nginx.vim]]
time([[Sourcing ftdetect script at: /home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-nginx/ftdetect/nginx.vim]], false)
time([[Sourcing ftdetect script at: /home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-haskell/ftdetect/haskell.vim]], true)
vim.cmd [[source /home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-haskell/ftdetect/haskell.vim]]
time([[Sourcing ftdetect script at: /home/thadeu/.local/share/nvim/site/pack/packer/opt/lang-haskell/ftdetect/haskell.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
