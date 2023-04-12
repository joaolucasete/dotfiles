{ pkgs, home-manager, username, ... }:

{
  virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = [ "docker" ];
}
