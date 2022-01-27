_complete_skey() {
	compadd $(ls $HOME/.ssh/keys/| grep -v '\.pub$');
}
compdef _complete_skey skey
