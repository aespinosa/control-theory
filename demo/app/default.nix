# To build on macOS
# NIX_CURRENT_LOAD=`pwd` NIX_REMOTE_SYSTEMS=`pwd`/remotes.conf \
# NIX_BUILD_HOOK=$HOME/.nix-profile/libexec/nix/build-remote.pl \
# nix-build  --argstr system x86_64-linux
#
# remotes.conf
# vagrant@<ip> x86_64-linux $HOME/.vagrant.sh/insecure_private_key 1
{ system ? builtins.currentSystem }:
with import <nixpkgs> {
  system = system;
};

stdenv.mkDerivation {
  name = "cpu-app";
  enableSharedExecutables = false;
  buildInputs = [
    (haskellPackages.ghcWithPackages (p: [p.yesod ]))
  ];

  src = ./.;

  phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];
}
