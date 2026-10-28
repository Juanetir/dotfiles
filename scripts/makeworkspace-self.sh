
#!/usr/bin/env bash
set -euo pipefail

# Get the currently active workspace ID.
current=$(hyprctl -j activeworkspace | jq -r '.id')

# Get occupied workspace IDs at or after the current one.
mapfile -t ids < <(
    hyprctl -j workspaces |
    jq -r --argjson n "$current" \
        '.[] | select(.id >= $n) | .id' |
    sort -rn
)

# Shift workspaces from right to left.
for id in "${ids[@]}"; do
    next=$((id + 1))

    # Move every window in this workspace.
    while read -r address; do
        [[ -z "$address" ]] && continue
        hyprctl dispatch movetoworkspacesilent "$next,address:$address"
    done < <(
        hyprctl -j clients |
        jq -r --argjson id "$id" \
            '.[] | select(.workspace.id == $id) | .address'
    )
done

# Activate the newly freed workspace.
hyprctl dispatch workspace "$current"
