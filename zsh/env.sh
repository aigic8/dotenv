
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

# setup nekoray as vpn
set_neko() {
	export http_proxy=127.0.0.1:2080
	export HTTP_PROXY=127.0.0.1:2080
	export https_proxy=127.0.0.1:2080
	export HTTPS_PROXY=127.0.0.1:2080
}

ff() {
	DIR_PATH="$(find $HOME/main $HOME/lab -maxdepth 1 -and -type d | fzf)"
	BASE_NAME="$(basename $DIR_PATH)"
	tmux new -c $DIR_PATH -s $BASE_NAME
}

