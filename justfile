host := "khakcsar"
rebuild := "nix run --inputs-from . nixpkgs#nixos-rebuild -- --no-reexec"

# List available recipes
# @ means it doesn't print the command before running it
default:
    @just --list

# Build on the server and switch to it (+ make it the boot default)
deploy:
    {{ rebuild }} switch --flake .#{{ host }} --target-host {{ host }} --build-host {{ host }} --sudo

# Activate without making it the boot default: a reboot undoes it (use for firewall/SSH/network changes)
test:
    {{ rebuild }} test --flake .#{{ host }} --target-host {{ host }} --build-host {{ host }} --sudo

# Switch back the the previous generation (nothing is built)
rollback:
    {{ rebuild }} switch --rollback --flake .#{{ host }} --target-host {{ host }} --sudo

# Evaluate the whole config locally (catches typos, builds nothing)
check:
    nix eval .#nixosConfigurations.{{ host }}.config.system.build.toplevel.drvPath

# List system generations on the server
gens:
    ssh {{ host }} sudo nix-env --list-generations -p /nix/var/nix/profiles/system

# Update flake.lock to the latest nixpkgs/disko (then: just check, just deploy)
update:
    nix flake update
