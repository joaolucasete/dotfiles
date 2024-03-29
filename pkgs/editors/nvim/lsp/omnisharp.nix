{ pkgs, prelude, ... }:

with pkgs;
{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    local pid = vim.fn.getpid()
    local omnisharp_bin = "${omnisharp-roslyn}/bin/OmniSharp"

    require('lspconfig').omnisharp.setup{
      cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
      on_attach = on_attach,
      capabilities = capabilities,
      handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
      },
    }
  '';
}
