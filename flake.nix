{
  description = "Onagre Development Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    rustVersion = pkgs.rustc.version;
  in
  {
    packages.${system}.default = with pkgs;
      mkShell {
        buildInputs = [
          glibc
          clang
          llvmPackages.bintools
          rustup
        ];
        nativeBuildInputs = [
          pop-launcher
          wayland.dev
        ];
        shellHook = ''
          export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
          export PATH=$PATH:''${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/
          rustup default stable
          cargo fetch
        '';
        RUSTC_VERSION = "1.75.0";
        LIBCLANG_PATH = pkgs.lib.makeLibraryPath [
          pkgs.llvmPackages_latest.libclang.lib
        ];
        RUSTFLAGS = (builtins.map (a: ''-L ${a}/lib'') [
        ]);
        BINDGEN_EXTRA_CLANG_ARGS =
        (builtins.map (a: ''-I"${a}/include"'')[
          pkgs.glibc.dev
        ])
        ++ [
          ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
          ''-I"${pkgs.glib.dev}/include/glib-2.0"''
          ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
        ];
      };
  };
}
