silent! GuiTabline 0
silent! GuiPopupmenu 0

if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility with HiDPI hints...
    if g:fvim_os == 'windows' || g:fvim_render_scale > 1.0
      set guifont=SauceCodePro\ Nerd\ Font:h18
    else
      set guifont=SauceCodePro\ Nerd\ Font:h26
    endif
else
    execute 'GuiFont! SauceCodePro Nerd Font:h13'
endif

set guicursor=a:block
set guicursor+=o:hor50-Cursor
set guicursor+=n:Cursor
set guicursor+=a:blinkon0
