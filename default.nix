let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  buildRubyGem = pkgs.buildRubyGem;
  multi_json = buildRubyGem {
    gemName = "multi_json";
    version = "1.11.2";
    src = pkgs.fetchurl {
      url = "https://rubygems.org/downloads/multi_json-1.11.2.gem";
      sha256 = "d9a4f2707792a55b3d09ed4ba7ea7d07ba83bf8652e0f7f1f234843824a1c3e5";
    };
  };
  iruby = buildRubyGem {
    gemName = "iruby";
    version = "0.2.8";
    src = pkgs.fetchurl {
      url = "https://rubygems.org/downloads/iruby-0.2.8.gem";
      sha256 = "0695f7755030d9ea71b1360b67f7c264deddb200f7bc079566e73c6bafdc18ae";
    };
  };
  bond = buildRubyGem {
    gemName = "bond";
    version = "0.5.1";
    src = pkgs.fetchurl {
      url = "https://rubygems.org/downloads/bond-0.5.1.gem";
      sha256 = "20710d17b16609b0dfbde9d828964b5eadb565513dbb68fb13d44f4d988b29e4";
    };
  };
  mimemagic = buildRubyGem {
    gemName = "mimemagic";
    version = "0.3.1";
    src = pkgs.fetchurl {
      url = "https://rubygems.org/downloads/mimemagic-0.3.1.gem";
      sha256 = "8fb981c19040ccc22888f17f2665ae829bc2fa0983b644c6947d4494b7d0a379";
    };
  };
  rbczmq = buildRubyGem {
    gemName = "rbczmq";
    version = "1.7.9";
    buildInputs = with pkgs; [ libtool autoconf automake ];
    src = pkgs.fetchurl {
      url = "https://rubygems.org/downloads/rbczmq-1.7.9.gem";
      sha256 = "dd8172a14df9fef212be7c7c60353561c2042e54ac78a37ed5c12c2b2a2119af";
    };
  };
  gnuplotRuby = buildRubyGem {
    gemName = "gnuplot";
    version = "2.6.2";
    src = pkgs.fetchurl {
      url = "https://rubygems.org/downloads/gnuplot-2.6.2.gem";
      sha256 = "d2c28d4a55867ef6f0a5725ce157581917b4d27417bc3767c7c643a828416bb3";
    };
  };
  gslRuby = buildRubyGem {
    gemName = "gsl";
    version = "1.16.0.6";
    buildInputs = [ pkgs.gsl_1 ];
    src = pkgs.fetchurl {
      url = "https://rubygems.org/downloads/gsl-1.16.0.6.gem";
      sha256 = "3fa354277d68a729e239a8c9eb3408f2978a444b7da3708cff120a9cb69cdcff";
    };
  };
in rec {
  notebookEnv = stdenv.mkDerivation {
    name = "controlTheory";
    buildInputs = [ pkgs.python3Packages.notebook iruby multi_json bond
                    mimemagic rbczmq gnuplotRuby pkgs.gnuplot gslRuby ];
  };
}
