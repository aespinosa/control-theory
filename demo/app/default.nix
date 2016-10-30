with import <nixpkgs> {};


stdenv.mkDerivation {
  name = "cpu-app";
  buildInputs = [
    (haskellPackages.ghcWithPackages (p: [p.yesod ]))
  ];
}
