{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "x230";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Lisbon";

  fonts.fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      hack-font
  ];
  
  environment.systemPackages = with pkgs; [

    emacs
    git
    python3
    sbcl

    dunst libnotify # notifications
    maim # screenshots
    xclip # clipboard
    feh
    
    # programs
    pass
    tdesktop
    firefox
    rxvt_unicode
    
  ];


  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    light.enable = true;
    fish.enable = true;
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

        #sessionCommands = ''
        #  # Network Manager Applet
        #  ${pkgs.networkmanagerapplet}/bin/nm-applet &
        #'';
        
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

    emacs.enable = true;
    acpid.enable = true;
    printing.enable = true;
    tlp.enable = true;
  };
  
  users.users.ratsclub = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "19.09"; 
}
