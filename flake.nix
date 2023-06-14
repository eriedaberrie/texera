{
  description = "Collaborative machine-learning-centric data analytics using workflows.";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... } : let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];
  in {
    devShell = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in pkgs.mkShell {
      buildInputs = builtins.attrValues rec {
        java = pkgs.temurin-bin-11;

        sbt = ((pkgs.sbt.overrideAttrs (_: rec {
          version = "1.5.5";
          src = pkgs.fetchurl {
            url = "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz";
            hash = "sha256-wPzVDPXJHtJ60BxcaocXticAyHpQ/5sOdXOyJ6yys8k=";
          };
        })).override {jre = java;});

        nodejs = pkgs.nodejs_18;

        yarn = (pkgs.yarn.override {inherit nodejs;});
      };
    });
  };
}
