# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # graphics drivers/32bit support
  hardware.graphics = {
   enable = true;
   enable32Bit = true;
 };
 
# Nvidia
 services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = true;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.production;
  open = true;   # RTX 4060 is Ada -> open module

  prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;   # provides the `nvidia-offload` wrapper
    };
    nvidiaBusId = "PCI:1:0:0";   # NVIDIA RTX 4060
    amdgpuBusId = "PCI:6:0:0";   # AMD 780M
  };
}; 

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hibernation
  boot.resumeDevice = "/dev/disk/by-uuid/26fe33e5-5140-41ba-b759-29693fcd4695";
  boot.kernelParams = [ "resume_offset=533760" ];
  powerManagement.enable = true;

  # Swap
  swapDevices = [{ device = "/swap/swapfile";}];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;  

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
   font = "Lat2-Terminus16";
   keyMap = "uk";
  # useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
   enable = true;
   pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.USER = {
   isNormalUser = true;
   extraGroups = [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
   shell = pkgs.fish;
  # packages = with pkgs; [
   # tree
   #];
  };

  programs.firefox.enable = true;

  # KDE Support
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;

  # LY Display Manager Support
  services.displayManager.ly.enable = true;

  # Fish Shell Support
  programs.fish.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   git
   unzip 
   ghostty
   zig_0_16
   zigfetch
   sdl3
   btop
   protonplus
   brightnessctl
  ];

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Steam Support
  programs.steam = {
   enable = true;
   remotePlay.openFirewall = true;
 };
  # GameMode
  programs.gamemode.enable = true;

  # Proton Support
  programs.steam.extraCompatPackages = with pkgs; [
   proton-ge-bin
 ];

  # Flatpak Support
  services.flatpak.enable = true;

  # Brightnessctl
  services.udev.packages = [pkgs.brightnessctl];  


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

