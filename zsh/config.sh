SCRIPT_DIR=$( dirname "$0" ) 

source "$SCRIPT_DIR/env.sh"
source "$SCRIPT_DIR/fzf.sh"
[ -s "$SCRIPT_DIR/custom.sh" ] && source "$SCRIPT_DIR/custom.sh"
