# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    default, normal, red, green, bold, reverse, dim, BRIGHT, default_colors,
)


class Default(ColorScheme):
    progress_bar_color = normal

    def use(self, context):  # pylint: disable=too-many-branches,too-many-statements
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = red
            if context.border:
                fg = default
            if context.media:
                if context.image:
                    fg = default
                else:
                    fg = default
            if context.container:
                fg = default
            if context.directory:
                attr |= bold
                fg = default
                fg += BRIGHT
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                attr |= bold
                fg = default
                fg += BRIGHT
            if context.socket:
                attr |= bold
                fg = default
                fg += BRIGHT
            if context.fifo or context.device:
                fg = default
                if context.device:
                    attr |= bold
                    fg += BRIGHT
            if context.link:
                fg = default
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = default
                fg += BRIGHT
            if not context.selected and (context.cut or context.copied):
                attr |= bold
                fg = default
                fg += BRIGHT
                # If the terminal doesn't support bright colors, use dim white
                # instead of black.
                if BRIGHT == 0:
                    attr |= dim
                    fg = default
            if context.main_column:
                # Doubling up with BRIGHT here causes issues because it's
                # additive not idempotent.
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = default
            if context.badinfo:
                if attr & reverse:
                    bg = red
                else:
                    fg = default

            if context.inactive_pane:
                fg = default

        elif context.in_titlebar:
            if context.hostname:
                fg = default
            elif context.directory:
                fg = default
            elif context.tab:
                if context.good:
                    bg = green
            elif context.link:
                fg = default
            attr |= bold

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = default
                elif context.bad:
                    fg = default
            if context.marked:
                attr |= bold | reverse
                fg = default
                fg += BRIGHT
            if context.frozen:
                attr |= bold | reverse
                fg = default
                fg += BRIGHT
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = default
                    fg += BRIGHT
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = default
                attr &= ~bold
            if context.vcscommit:
                fg = default
                attr &= ~bold
            if context.vcsdate:
                fg = default
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = default

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = default
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = default
            elif context.vcsuntracked:
                fg = default
            elif context.vcschanged:
                fg = default
            elif context.vcsunknown:
                fg = default
            elif context.vcsstaged:
                fg = default
            elif context.vcssync:
                fg = default
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = default
            elif context.vcsbehind:
                fg = default
            elif context.vcsahead:
                fg = default
            elif context.vcsdiverged:
                fg = default
            elif context.vcsunknown:
                fg = default

        return fg, bg, attr
