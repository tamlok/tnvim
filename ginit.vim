silent! GuiTabline 0
silent! GuiPopupmenu 0

if exists('g:fvim_loaded')
    if g:fvim_os == 'windows' || g:fvim_render_scale > 1.0
      set guifont=SauceCodePro\ Nerd\ Font\ Mono:h18
    else
      set guifont=SauceCodePro\ Nerd\ Font\ Mono:h26
    endif
else
    if exists(":GuiFont")
        execute 'GuiFont! SauceCodePro\\ Nerd\\ Font\\ Mono:h13'
    endif
endif

set guicursor=a:block
set guicursor+=o:hor50-Cursor
set guicursor+=n:Cursor
set guicursor+=a:blinkon0
