	if [[ -z "$MONOREPO_ROOT" ]]; then
		local bin=$(dirname $(readlink -f "$0"))
		MONOREPO_ROOT=$(readlink -f "${bin}/..")
	fi