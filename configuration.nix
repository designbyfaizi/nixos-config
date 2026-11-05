{ modulesPath, pkgs, ... }:

let
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkET8BVB5I7DG+HclD10fPsC3T/DLVJjSlo0AQjk4ur";
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ./hardware-configuration.nix
    ./caddy.nix
  ];

  # ── Boot ──────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "console=ttyAMA0" "console=tty1" ];


  # ── Network ───────────────────────────────────────────
  networking.hostName = "khakcsar";
  networking.useDHCP = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };

  time.timeZone = "UTC";


  # ── SSH ───────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };


  # ── Users ─────────────────────────────────────────────
  users.users.khakcsar = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "REMOVED";
    openssh.authorizedKeys.keys = [ sshKey ];
  };
  users.mutableUsers = false;
  security.sudo.wheelNeedsPassword = false;


  # ── Nix itself ────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@wheel" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;


  # ── System ────────────────────────────────────────────
  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    fresh-editor
    htop
    btop
    curl
    tree # shows directory trees
    ncdu # interactive disk-usage
  ];

  system.stateVersion = "26.05";
}
