function ProjectPath()
	let path = split(expand('%:p:h'),'/')

	while len(path[1:])
		let dir = '/'.join(path,'/').'/.vimproject'
		if isdirectory(dir)
			let g:projectDir='/'.join(path,'/')
			let g:projectConfDir=dir
			let g:projectConfFile=g:projectConfDir.'/conf.vim'
			let g:projectSessionFile=g:projectConfDir.'/session.vim'
			let g:NERDTreeBookmarksFile=g:projectConfDir.'/bookmarks'
			let g:projectTagsDir=g:projectConfDir.'/tags'
			if filereadable(g:projectConfFile)
				exe 'so '.g:projectConfFile
			end
			break
		else
			let path=path[:-2]
		endif
	endwhile
endfunction

function ProjectLoadTags()
    if exists('g:projectDir')
        let tagfile=g:projectTagsDir.'/'.&filetype.'.tags'
        if filereadable(tagfile)
            exe 'setlocal tags='.tagfile
            set notagrelative
            exe 'lchdir '.g:projectDir
        endif
    endif
endfunction

function ProjectLoadSession()
	if exists('g:projectDir') && filereadable(g:projectSessionFile)
		exec 'so '.g:projectSessionFile
	end
endfunction

function ProjectSave()
	if exists('g:projectDir') && isdirectory(g:projectConfDir)
		set sessionoptions=buffers,tabpages,unix,curdir
		exec 'mksession! '.g:projectSessionFile
	endif
endfunction

function ProjectSet()
	!mkdir $PWD/.vimproject
	call ProjectPath()
endfunction

function ProjectGenTags()
	let pwd=$PWD
    exe '!mkdir -p '.g:projectTagsDir
	exec '!cd '.g:projectDir
    exec '!ctags --languages=javascript --tag-relative=no --verbose=no --exclude=*.min.js --exclude=*.css --exclude=*.php --exclude=*.html --exclude=*wp-admin* -f '.g:projectTagsDir.'/javascript.tags -R . '
    exec '!ctags --languages=lua --tag-relative=no --verbose=no -f '.g:projectTagsDir.'/lua.tags -R .'
    exec '!ctags --languages=php --tag-relative=no --verbose=no -f '.g:projectTagsDir.'/php.tags -R .'
    exec '!ctags --languages=python --tag-relative=no --verbose=no -f '.g:projectTagsDir.'/python.tags -R .'
	exec '!cd '.pwd
	call ProjectLoadTags()
endfunction


" ------ Execuction ------
call ProjectPath()
augroup Project
	nmap <silent> <Leader>pl :call ProjectLoadSession()<CR>
	nmap <silent> <Leader>ps :call ProjectSave()<CR>
	" au VimEnter * :call ProjectLoadSession()
	au FileType * :call ProjectLoadTags()
augroup END


