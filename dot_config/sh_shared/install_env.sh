ENV_PATH="$SH_SHARED_DIR/env"
if [[ -e "$ENV_PATH" ]]; then
	export $(envsubst < "$ENV_PATH")
fi