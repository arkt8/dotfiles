dotfile-update() {
    if [[ -z "$DOTHOST" ]] ; then
        echo "you need configure source host to continue:"
        echo "export DOTHOST=username@host"
        exit return 1
    fi
    echo -e "\n## Getting termux dotfiles from $DOTHOST ##\n"
    rm -rf $HOME/.dotfiles.bkp
    mv $HOME/.dotfiles $HOME/.dotfiles.bkp
    scp -r $DOTHOST:.config/dotfiles/termux \
           $HOME/.dotfiles && \
           echo -e "\n## Installing updated termux dotfiles ##\n" && \
           bash $HOME/.dotfiles/install.sh && return 0
    cp -rf $HOME/.dotfiles.bkp $HOME/.dotfiles && \
    echo -e "\n## Update failed, restored backup ##\n"
    return 1
}
