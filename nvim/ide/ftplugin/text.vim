set ts=2 sw=2 sts=2
set foldmethod=indent foldenable colorcolumn=80

"set foldmethod=marker foldmarker=·>,·· foldenable
"function Ide_FoldText()
"	let line = getline(v:foldstart)
"	let sub = substitute( line, '·>\s*$','','g')
"	let start = substitute( v:folddashes, '^.', '', 'g' )
"	return start . sub
"endfunction
"setlocal foldtext=Ide_FoldText()
