# vim: set tw=0:
with import <nixpkgs> {};
let
  bbl = stdenv.mkDerivation {
    name = "bbl-6.6.8";
    src = fetchurl {
      url = "https://github.com/cloudfoundry/bosh-bootloader/releases/download/v6.4.8/bbl-v6.4.8_osx";
      sha256 = "1bjcwqhximb9bly4cixv2qkj2l724qmh2zhgppgpncl81yfw7alh";
    };
    buildCommand = ''
      mkdir -p $out/bin
      cp $src $out/bin/bbl
      chmod 755 $out/bin/bbl
    '';
  };
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
  cf = stdenv.mkDerivation {
    name = "cf-6.35.2";
    src = fetchurl {
      url = "https://s3-us-west-1.amazonaws.com/cf-cli-releases/releases/v6.35.2/cf-cli_6.35.2_osx.tgz";
      sha256 = "0jvxmvvh61fd5wd4k1y32nlfgxrwwn0g2bar52i4g1gap80xlmrf";
    };
    buildCommand = ''
      mkdir -p $out/bin
      tar -xvzf $src
      cp cf $out/bin/cf
      chmod 755 $out/bin/cf
    '';
  };
  uaa = stdenv.mkDerivation {
    name = "uaac-4.1.0";
    buildInputs = [ ruby makeWrapper ];
    buildCommand = ''
       GEM_HOME=$out gem install --no-doc cf-uaac --version 4.1.0
       rm -fv $out/bin/*
       makeWrapper ${ruby}/bin/ruby $out/bin/uaac \
          --add-flags $out/gems/cf-uaac-4.1.0/bin/uaac \
          --set GEM_HOME $out
    '';
  };
  vegeta = stdenv.mkDerivation {
    name = "vegeta-6.3.0";
    src = fetchurl {
      url = "https://github.com/tsenart/vegeta/releases/download/v6.3.0/vegeta-v6.3.0-darwin-amd64.tar.gz";
      sha256 = "0rwbc3gcwh3s2i412l2i20na5cn1yckhiz80i13zdfdhprj35pyv";
    };
    buildCommand = ''
      mkdir -p $out/bin
      tar -xvzf $src
      cp vegeta $out/bin/vegeta
      chmod 755 $out/bin/vegeta
    '';
  };
in
stdenv.mkDerivation {
  name = "cfsummit-2018";
  buildInputs = [ bosh bbl terraform ruby cf uaa vegeta ];
  shellHook = ''
     alias bbl='bbl -s bbl_state'
     export BBL_GCP_SERVICE_ACCOUNT_KEY=$(pwd)/key.json
  '';
}
