with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "demo";
  src = ./.;

  buildInputs = [ terraform kubernetes google-cloud-sdk ];
}
