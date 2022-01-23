"
"syn keyword phpRepeat      for endfor foreach endforeach while endwhile repeat do
"hi! link phpRepeat Repeat
"
syn keyword phpConditional if endif else elseif case switch endswitch
"
"syn keyword phpLabel       static public private protected interface mixin extends final
"hi! link phpLabel Label

syn keyword phpStatement function
      \ nextgroup=phpFunction skipwhite skipempty
syn match phpFunction /\h\w*/ contained
hi! link phpFunction Function


syn keyword phpStatement class
      \ nextgroup=phpClass skipwhite skipempty
syn match phpClass /\h\w*/ contained
hi! link phpClass Typedef




syn keyword phpStatement   use fn namespace
