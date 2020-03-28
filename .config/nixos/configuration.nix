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
      hack-font
      dina-font
      unstable.uw-ttyp0
      ibm-plex
      terminus
    ];

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    light.enable = true;
    nm-applet.enable = true;
  };

  sound.enable = true;
  nixpkgs.config.pulseaudio = true;

  hardware = {
    pulseaudio.enable = true;
    brightnessctl.enable = true;
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

      displayManager = {
        lightdm.enable = true;
      };
      
      desktopManager = {
        default = "none";
        xterm.enable = false;
      };

      windowManager = {
         i3.enable = true;
      };      

      enable = true;
      libinput.enable = true;
    };

    ipfs = {
      enable = true;
      enableGC = true;
    };
    
    emacs = {
      enable = true;
      install = true;
      package = import ./emacs.nix { inherit pkgs; };
      defaultEditor = true;
    };
    
    acpid.enable = true;
    printing.enable = true;
    tlp.enable = true;
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
      feh
      firefox
      fzf
      git
      htop
      httpie
      imagemagick
      jq
      maim
      pass
      ripgrep
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
