with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "demo";

  buildInputs = [
    terraform kubernetes google-cloud-sdk minikube
  ];
}
