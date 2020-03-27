{ pkgs ? import <nixpkgs> {} }: 

let
  myEmacs = (pkgs.emacs.override {
    withGTK3 = true;
    withGTK2 = false;
  }).overrideAttrs (attrs: {
    postInstall = (attrs.postInstall or "") + ''
      rm $out/share/applications/emacs.desktop
    '';
  });
  emacsWithPackages = (pkgs.emacsPackagesGen myEmacs).emacsWithPackages; 
in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    evil
    magit
  ]) ++ (with epkgs.melpaPackages; [
     async
     beacon
     cyberpunk-theme
     company
     diminish
     exec-path-from-shell
     htmlize
     ido-vertical-mode
     neotree
     nix-mode
     powerline
     slime
     swiper
     switch-window
     use-package
     which-key
  ]) ++ (with epkgs.elpaPackages; [
     beacon
     nameless
  ]))
