with import <nixpkgs> {};
let
    bosh = stdenv.mkDerivation {
      name = "bosh-3.0.1";
      src = fetchurl {
        url = "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-3.0.1-darwin-amd64";
        sha256 = "01mhfmlb7ww0fzyw5s4k9bzdrawl2rgxh3ryzd5ha646dvhpjj9g";
      };
      buildCommand = ''
          mkdir -p $out/bin
          cp $src $out/bin/bosh
          chmod 755 $out/bin/bosh
      '';
    };
in
stdenv.mkDerivation {
  name = "cfsummit-2018";
  buildInputs = [ bosh ];
}
