set mouse=""
set encoding=utf-8
set number
set relativenumber
set cursorline
set noswapfile
set scrolloff=7

set nobackup
set nowritebackup

set fileformat=unix
filetype indent on      " load filetype-specific indent files

" for tabulation
set smartindent
set tabstop=2
set expandtab
set shiftwidth=2

" horizontal split open below and right
set splitbelow
set splitright

call plug#begin('~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }

Plug 'xiyaowong/transparent.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'morhetz/gruvbox'

""Plug 'scrooloose/nerdtree', {'on':'NERDTreeToggle'}
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'windwp/nvim-autopairs'
Plug 'numToStr/Comment.nvim'
Plug 'folke/flash.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

"" COLORSCHEME / THEME

""colorscheme gruvbox
colorscheme catppuccin
if (has('termguicolors'))
  set termguicolors
endif

""let g:transparent_enabled = v:true

let mapleader = " "

"" KEYBINDS

" save and quit
nnoremap <Leader>w :w<Return>
nnoremap <C-s> :w<Return>
nnoremap <Leader>q :q<Return>
nnoremap <Leader>Q :qa<Return>

"split screen
nnoremap ss <C-w>s<CR>
nnoremap sv <C-w>v<CR>

"window navigation
nnoremap sh <C-w>h
nnoremap sl <C-w>l
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" new tab creation and tab navigation
nnoremap <Leader>n :tabnew<cr>
nnoremap <Leader>l :tabnext<cr>
nnoremap <Leader>h :tabprevious<cr>

"increment & decrement
nnoremap + <C-a>
nnoremap - <C-x>

"select all
nnoremap <C-a> gg<S-v>G

"NvimTree
nnoremap <Leader>e :NvimTreeToggle<CR>
nnoremap <Leader>o :NvimTreeFocus<CR>

" turn off search highlight
nnoremap ,<space> :nohlsearch<CR>

" find files using telescope command-line sugar.
nnoremap ,f <cmd>Telescope find_files<cr>
nnoremap ,g <cmd>Telescope live_grep<cr>
nnoremap ,b <cmd>Telescope buffers<cr>
nnoremap ,h <cmd>Telescope help_tags<cr>

" terminal
nnoremap <F7> <C-w>s<CR><cmd>terminal<cr>

" autocomplete
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" formatting
xmap <leader>f  <Plug>(coc-format)
nmap <leader>f  <Plug>(coc-format)

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Running code
autocmd FileType python map <buffer> <Leader>z kk:w<CR>ss :terminal python %<CR>
autocmd FileType cpp map <buffer> <Leader>z kk:w<CR>:exec '!g++' shellescape(@%, 1) '-o out'<CR>ss :terminal ./out<CR>

lua << EOF

require('Comment').setup()
require("nvim-autopairs").setup {map_cr=false}
require("nvim-tree").setup()
require("flash").setup()
require("ibl").setup {
  indent = {
    char = '▏',
    highlight = highlight
  },
  scope = { show_start = false, show_end = false }
}



-- TreeSitter highlight
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "cpp", "lua", "vim", "python"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

EOF
