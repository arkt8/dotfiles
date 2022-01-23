call plug#begin('~/.config/nvim-plugged/')
" Themes
"	Plug 'ghifarit53/tokyonight-vim'             , { 'as':'cs-tokyonite' }
"	Plug 'jacoborus/tender.vim'                  , { 'as':'cs-tender'    }
"	Plug 'kxmndev/vim-mana'                      , { 'as':'vim-mana'     }
"	Plug 'whatyouhide/vim-gotham'                , { 'as':'cs-gotham'    }
"	Plug 'ajmwagar/vim-deus'                     , { 'as':'cs-vim-deus' }
"	Plug 'pineapplegiant/spaceduck'              , { 'as':'cs-spaceduck' }
"	Plug 'ulwlu/elly.vim'                        , { 'as':'cs-elly.vim' }
"	Plug 'rafi/awesome-vim-colorschemes'         , { 'as':'cs-awesome-vim-colorschemes' }
"	Plug 'rainglow/vim'                          , { 'as':'cs-vim' }
"	Plug 'chriskempson/base16-vim'               , {'as':'cs-base16-ck'}
"	Plug 'EdenEast/nightfox.nvim'                , {'as':'cs-nightfox'  }
"	Plug 'sainnhe/sonokai'                       , {'as':'cs-sonokai'   }


" BAAAAAAD ---------------------------------------------------------------
"	Plug 'keith/parsec.vim'                      , { 'as':'cs-parsec'    }
"	Plug 'Marfisc/vorange'                       , { 'as':'cs-vorange'   }
"	Plug 'ewilazarus/preto'                      , { 'as':'cs-preto'     }
" END Themes (sort -k4)

" Interface
	Plug 'plasticboy/vim-markdown'        , { 'as': 'lang-markdown', 'for': [ 'markdown','md','MD','mdown' ] }
	Plug 'junegunn/fzf'                   , { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/limelight.vim'         " Focus Mode
"	Plug 'ctrlpvim/ctrlp.vim'             " Fuzzy file, buffer, mru, tag, ... finder
"
"	Plug 'chr4/nginx.vim'                , { 'as': 'lang-nginxconf',  'for': 'nginx' } " Nginx + Lua blocks
	Plug 'dense-analysis/ale'             , { 'as': 'lang-ale'}
"	Plug 'andrejlevkovitch/vim-lua-format', { 'as': 'lang-luaformat' }
	Plug 'mrk21/yaml-vim'                 , { 'as': 'lang-yaml' }
	Plug 'neovimhaskell/haskell-vim'      , { 'as': 'lang-haskell' }
	Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
"
"	Plug 'tpope/vim-fugitive'            " Git plugin
"	Plug 'axvr/org.vim'                  " Org Mode

"LSP
	"if $SSH_CONNECTION == ""
		Plug 'neoclide/coc.nvim', {'branch': 'release'}
	"endif
call plug#end()


"	Plug 'zah/nim.vim'                    , { 'as': 'lang-nim',        'for': 'nim' }
"	Plug 'StanAngeloff/php.vim'           , { 'as': 'lang-php',        'for': 'php' }
"	Plug 'vim-python/python-syntax'       , { 'as': 'lang-python',     'for': 'python' }
"	Plug 'rust-lang/rust.vim'             , { 'as': 'lang-rust',       'for': 'rust' }
"	Plug 'arzg/vim-sh'                    , { 'as': 'lang-shellscript','for': [ 'zsh','bash','sh' ] }
"	Plug 'timcharper/textile.vim'         , { 'as': 'lang-textile',    'for': [ 'textile','ttn' ] }
"	Plug 'sheerun/vim-polyglot'           , { 'as': 'lang-polyglot' }
