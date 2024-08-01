
# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# bun completions
BUN_PATH="$HOME/.bun/_bun"
[ -s $BUN_PATH ] && source $BUN_PATH

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# go
GO_BIN="/usr/local/go/bin"
if [ -d "$GO_BIN" ]; then
	export PATH=$PATH:/usr/local/go/bin
fi

# aliases and functions
alias open="xdg-open"
alias tmux="TERM=alacritty-direct tmux"

ff() {
	DIR_PATH="$(find $HOME/main $HOME/lab -maxdepth 1 -and -type d | fzf)"
	BASE_NAME="$(basename $DIR_PATH)"
	tmux new -c $DIR_PATH -s $BASE_NAME
}
