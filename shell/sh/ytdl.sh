# This function is based on youtube-dl.plugin.zsh

ytdl() {
	YTDLPATH=/home/thadeu/.local/git/youtube-dl/
	PYTHONPATH=$YTDLPATH $YTDLPATH/bin/youtube-dl "$@"
}


