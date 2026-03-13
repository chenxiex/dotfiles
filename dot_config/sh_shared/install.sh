### aliases
ALIAS_PATH="$SH_SHARED_DIR/alias"
if [[ -e "$ALIAS_PATH" ]]; then
	source "$ALIAS_PATH"
fi
### End of aliases

### functions
FUNC_PATH="$SH_SHARED_DIR/func"
if [[ -e "$FUNC_PATH" ]]; then
	source "$FUNC_PATH"
fi
### End of functions