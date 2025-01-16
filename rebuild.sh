set -e
cd /etc/nixos

send_notification() {
    local title="$1"
    local message="$2"
    local icon="$3"
    
    local user_id=$(id -u $SUDO_USER)
    sudo -u $SUDO_USER DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$user_id/bus notify-send "$title" "$message" --icon="$icon" -a "NixOS Rebuild"
}

if [[ "$1" != "--force" && "$1" != "-f" ]]; then
    if git diff --quiet '*.nix'; then
       echo "No changes detected, exiting."
       popd &>/dev/null
       exit 0
    fi
fi

alejandra . &>/dev/null \
 || ( alejandra . ; echo "formatting failed!" && exit 1)


git diff -U0 '*.nix'


host=$(hostname | tr '[:upper:]' '[:lower:]')

echo "Rebuilding NixOS//$host"

if ! sudo nixos-rebuild switch --flake /etc/nixos#$host &>nixos-switch.log; then
    error_msg=$(cat nixos-switch.log | grep --color error)
    send_notification "NixOS Rebuild Failed" "Error: $error_msg" "error"
    exit 1
fi

current=$(nixos-rebuild list-generations | grep current).
git commit -am "$current"
popd &>/dev/null

send_notification "NixOS Rebuild" "System successfully updated to:\n$current" "software-update-available"