ENV_PATH="$SH_SHARED_DIR/env"
if [[ -e "$ENV_PATH" && -z $_INSTALLED_ENV ]]; then
	export _INSTALLED_ENV=1
	source "$ENV_PATH"
fi