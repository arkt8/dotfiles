require('telescope').setup{
   defaults = {
      layout_strategy = "flex",
      layout_config = {
         width =  0.99999,
         height = 0.99999,
      },
   },
      picker = {
         layout_config = { preview_cutoff = 10 }
      }
}
