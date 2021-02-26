{ pkgs ? import <nixpkgs> {} }:
let
in
pkgs.mkShell rec {
  name = "gotham-client";
  buildInputs = with pkgs; [
    glib
    gcc
    gmp
  ];
  nativeBuildInputs = buildInputs;
  #LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath nativeBuildInputs;
  #PKG_CONFIG_PATH= pkgPath;
  OPENSSL_DIR="${pkgs.openssl.dev}";
  OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib";
}
