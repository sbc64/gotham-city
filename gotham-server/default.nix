let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  pkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
in
with pkgs;
pkgs.stdenv.mkDerivation rec {
  name = "gotham-server";
  nativeBuildInputs = [ cmake pkgconfig clang ninja ];
  buildInputs = [
    gmp
    llvmPackages.libclang
    latest.rustChannels.nightly.rust
    ninja
    cmake
    libbacktrace
  ];
  LD_LIBRARY_PATH = lib.makeLibraryPath [ cmake llvmPackages.libclang gmp ];
  LIBCLANG_PATH="${pkgs.llvmPackages.libclang}/lib";

  NIX_LDFLAGS="-L${gccForLibs}/lib/gcc/${targetPlatform.config}/${gccForLibs.version}";
  cmakeFlags = [
    "-DGCC_INSTALL_PREFIX=${gcc}"
    "-DC_INCLUDE_DIRS=${stdenv.cc.libc.dev}/include:${libbacktrace}/include"
    "-GNinja"
    # Debug for debug builds
    "-DCMAKE_BUILD_TYPE=Release"
    # inst will be our installation prefix
    "-DCMAKE_INSTALL_PREFIX=../inst"
    "-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON"
    # change this to enable the projects you need
    "-DLLVM_ENABLE_PROJECTS=clang;libcxx;libcxxabi"
    # this makes llvm only to produce code for the current platform, this saves CPU time, change it to what you need
    "-DLLVM_TARGETS_TO_BUILD=host"
  ];


  OPENSSL_DIR="${openssl.dev}";
  OPENSSL_LIB_DIR="${openssl.out}/lib";
}
