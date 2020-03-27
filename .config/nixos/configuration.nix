{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    hostName = "x230";
    extraHosts = "127.0.1.1 x230";
    
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Lisbon";

  fonts.fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      hack-font
      dina-font
      ibm-plex
  ];
  
  environment.systemPackages = with pkgs; [
    rxvt_unicode
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
    
    emacs = {
      enable = false;
      install = true;
      defaultEditor = true;
    };
    
    acpid.enable = true;
    printing.enable = true;
    tlp.enable = true;
  };

  virtualisation.docker.enable = true;
  
  users.users.ratsclub = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    packages = with pkgs; [
      bc
      broot
      (import ./emacs.nix { inherit pkgs; })
      feh
      firefox
      fzf
      git
      htop
      jq
      maim
      pass
      ripgrep
      st
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
