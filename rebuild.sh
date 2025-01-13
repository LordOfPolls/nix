set -e
cd /etc/nixos

#if git diff --quiet '*.nix'; then
#    echo "No changes detected, exiting."
#    popd &>/dev/null
#    exit 0
#fi
#alejandra . &>/dev/null \
#  || ( alejandra . ; echo "formatting failed!" && exit 1)


git diff -U0 '*.nix'


host=$(hostname | tr '[:upper:]' '[:lower:]')

echo "Rebuilding NixOS//$host"

sudo nixos-rebuild switch --flake /etc/nixos#$host &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

current=$(nixos-rebuild list-generations | grep current).
git commit -am "$current"
popd &>/dev/null
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
