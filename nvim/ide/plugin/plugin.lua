local idepath = vim.fn.expand('<sfile>:p:h:h')
IDE = {}
function fileExists (f)
   local f= io.open (f, "r")

end

function IDE.filePath( x )
   local f = io.open ( x, "r" )
   if f~= nil then
      f:close()
      return idepath..'/'..x
   end
end
