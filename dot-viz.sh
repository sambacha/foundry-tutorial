#!/usr/bin/env bash
set -eo pipefail
shopt -s lastpipe

lockFile=$(realpath "${1:-./.dapp.json}")
jqExpr='
  (.contracts * {this:.this}) | values | .[]
    | "\""
    + (.deps | keys | .[])
    + "\" -> \""
    + (.name)
    + "\""
'
graph=$(
  jq -r "$jqExpr" "$lockFile" \
    | sort -u
)

if [[ $GRAPH_ONLY ]]; then
  echo "$graph"
else
  echo "digraph G {
  splines=ortho
$graph
  }" | dot -Tsvg
fi
