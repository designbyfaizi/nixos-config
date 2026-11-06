{ pkgs, ... }:

let
  domain = "130-162-255-5.sslip.io";

  # A tiny website, built as a package in Nix store
  site = pkgs.writeTextDir "index.html" ''
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>khakcsar</title>
      </head>
      <body>
        <h1>Hello from NixOS on Oracle Cloud 🗿</h1>
        <p>
          Served by Caddy, configured declaratively.
        </p>
      </body>
    </html>
  '';
in
{
  services.caddy = {
    enable = true;
    virtualHosts.${domain}.extraConfig = ''
      root * ${site}
      file_server
    '';
  };
}
