const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#202020", /* black   */
  [1] = "#df1902", /* red     */
  [2] = "#3a7475", /* green   */
  [3] = "#df6601", /* yellow  */
  [4] = "#1c575b", /* blue    */
  [5] = "#b4060a", /* magenta */
  [6] = "#253749", /* cyan    */
  [7] = "#cab399", /* white   */

  /* 8 bright colors */
  [8]  = "#4e4e4e",  /* black   */
  [9]  = "#ff3902",  /* red     */
  [10] = "#40a1a3", /* green   */
  [11] = "#ff8601", /* yellow  */
  [12] = "#1d8188", /* blue    */
  [13] = "#e20106", /* magenta */
  [14] = "#2d4b5f", /* cyan    */
  [15] = "#ffdcb5", /* white   */

  /* special colors */
  [256] = "#000000", /* background */
  [257] = "#ffdcb5", /* foreground */
  [258] = "#ffdcb5",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
