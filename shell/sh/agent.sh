agent() {
	ssh-agent -k
	eval $(ssh-agent -s)
	case "$1" in
		gh-lebeu) ssh-add ~/.ssh/github-lebeu ;;
	esac
}
