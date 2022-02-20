do local _ = vim.opt
_.readonly   = false
_.scrollbind = true
_.cursorbind = true
end

vim.cmd[[colorscheme Gotham]]

-- TODO: Needs to be migrated
--[[
:" Re-enable or update diff highlights
:imap <F5> :set hl&:diffupdatei
:map <F5> :set hl&:diffupdate

" Disable diff highlights
:imap <S-F5> :set hl+=A:none,C:none,D:none,T:nonei
:map <S-F5> :set hl+=A:none,C:none,D:none,T:none
]]
