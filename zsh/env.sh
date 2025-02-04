
alias k=kubectl
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
	local dir_path="$(find $HOME/main $HOME/lab -maxdepth 1 -and -type d | fzf)"
	local path_basename="$(basename $dir_path)"
	tmux new -c $dir_path -s $path_basename
}

alias vv="source ./venv/bin/activate"

py_proj() {
	local dest_path=$1
	mkdir $dest_path
	cd $dest_path 
	python -m venv venv
	source venv/bin/activate
	nvim .
}

