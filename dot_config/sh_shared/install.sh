### aliases
ALIAS_PATH="$SH_SHARED_DIR/alias"
if [[ -e "$ALIAS_PATH" && -z $_INSTALLED_ALIAS ]]; then
	export _INSTALLED_ALIAS=1
	source "$ALIAS_PATH"
fi
### End of aliases

### functions
FUNC_PATH="$SH_SHARED_DIR/func"
if [[ -e "$FUNC_PATH" && -z $_INSTALLED_FUNC ]]; then
	export _INSTALLED_FUNC=1
	source "$FUNC_PATH"
fi
### End of functions