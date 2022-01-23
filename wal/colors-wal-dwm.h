static const char norm_fg[] = "#ffdcb5";
static const char norm_bg[] = "#202020";
static const char norm_border[] = "#4e4e4e";

static const char sel_fg[] = "#ffdcb5";
static const char sel_bg[] = "#3a7475";
static const char sel_border[] = "#ffdcb5";

static const char urg_fg[] = "#ffdcb5";
static const char urg_bg[] = "#df1902";
static const char urg_border[] = "#df1902";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
