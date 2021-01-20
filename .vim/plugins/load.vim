call plug#begin('~/.vim/plugged')
if !has('nvim')
    Plug 'rhysd/vim-healthcheck'
endif
" GOLANG 
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" THEME
Plug 'NLKNguyen/papercolor-theme'

call plug#end()
