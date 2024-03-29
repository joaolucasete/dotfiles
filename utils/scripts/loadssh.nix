{ pkgs, ... }:

let
  jq = "${pkgs.jq}/bin/jq";
  bw = "${pkgs.bitwarden-cli}/bin/bw";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "loadssh" ''
      ${bw} login --apikey
      key=$(${bw} unlock --raw)
      private=~/.ssh/id_ed25519
      public=~/.ssh/id_ed25519.pub

      mkdir -p ~/.ssh

      ${bw} get item --session "$key" SSH_ED25519_PRIV | ${jq} -r '.notes' > "$private"
      ${bw} get item --session "$key" SSH_ED25519_PUB | ${jq} -r '.notes' > "$public"

      ${bw} lock

      chmod 600 "$private" "$public"
    '')
  ];
}
