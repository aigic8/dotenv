
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

