{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    plymouth.enable = true;
  };
  
  # audio
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;

  # powermanagement
  powerManagement.enable = true;
  services.acpid.enable = true;
  services.tlp.enable = true;

  networking = {
    hostName = "x230";
    extraHosts = "127.0.1.1 x230";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Lisbon";

  fonts.fonts = with pkgs;
    let unstable = import <nixos-unstable> {};
    in [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      unstable.uw-ttyp0
    ];

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    light.enable = true;
    nm-applet.enable = true;
  };
  
  hardware = {
    brightnessctl.enable = true;
    bluetooth.enable = true;
  };
  
  services = {

    compton = {
      enable = true;
      fade = true;
      inactiveOpacity = "1.0";
      shadow = true;
      fadeDelta = 4;
      vSync = true;
      backend = "glx";
    };

    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      windowManager.i3.enable = true;
      libinput.enable = true;
    };

    ipfs = {
      enable = true;
      enableGC = true;
    };
    
    emacs = {
      enable = false;
      install = true;
      package = import ./emacs.nix { inherit pkgs; };
      defaultEditor = true;
    };
    
    printing.enable = true;
  };
  
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };

    lxd.enable = true;
  };  

  users.users.ratsclub = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "docker"
      "lxd"
    ];
    packages = with pkgs; [
      aria2
      bc
      broot
      cargo
      feh
      firefox
      fzf
      gcc
      git
      hsetroot
      htop
      httpie
      hugo
      imagemagick
      jq
      maim
      nodejs-12_x
      pass
      ripgrep
      rustc
      rxvt_unicode
      tdesktop
      xclip
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system = {
    stateVersion = "19.09";
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = true;
  };

}
