{
  description = "BLIP: BLoom-then-flIP";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux" "aarch64-linux" "armv7l-linux"
        "x86_64-darwin" "aarch64-darwin"
      ];
      supportedOcamlPackages = [
        "ocamlPackages_4_10"
        "ocamlPackages_4_11"
        "ocamlPackages_4_12"
      ];
      defaultOcamlPackages = "ocamlPackages_4_12";

      forAllOcamlPackages = nixpkgs.lib.genAttrs supportedOcamlPackages;
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor =
        forAllSystems (system:
          import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          });
    in
      {
        overlay = final: prev:
          with final;
          let mkOcamlPackages = prevOcamlPackages:
                with prevOcamlPackages;
                let ocamlPackages = {
                      inherit ocaml;
                      inherit findlib;
                      inherit ocamlbuild;
                      inherit opam-file-format;
                      inherit buildDunePackage;

                      bitv =
                        buildDunePackage rec {
                          pname = "bitv";
                          version = "1.4";
                          src = fetchFromGitHub {
                            owner = "backtracking";
                            repo = pname;
                            rev = version;
                            sha256 = "0mhnbwnw06s6kknxygm0fa51gb1wd6y8npfq6r5dvlmmpgf7xgm8";
                          };

                          useDune2 = true;
                        };

                      bloomf =
                        buildDunePackage rec {
                          pname = "bloomf";
                          version = "0.1.0-bits";
                          src = fetchFromGitHub {
                            owner = "p2pcollab";
                            repo = pname;
                            rev = "cbffe83255cb12f5117825f8f8ebf363e18bd627";
                            sha256 = "0p4l8fib72vmbyk5izlsfawyxfz3wgcg2c2vglqf5103y28xi1jg";
                          };

                          useDune2 = true;

                          buildInputs = with ocamlPackages; [
                            bitv
                          ];
                        };

                      blip =
                        buildDunePackage rec {
                          pname = "blip";
                          version = "0.0.1";
                          src = self;

                          useDune2 = true;
                          doCheck = true;

                          nativeBuildInputs = with ocamlPackages; [
                            odoc
                            ounit
                          ];
                          buildInputs = with ocamlPackages; [
                            bloomf
                            bitv
                            nocrypto
                          ];
                        };
                    };
                in ocamlPackages;
          in
            let allOcamlPackages =
                  forAllOcamlPackages (ocamlPackages:
                    mkOcamlPackages ocaml-ng.${ocamlPackages});
            in
              allOcamlPackages // {
                ocamlPackages = allOcamlPackages.${defaultOcamlPackages};
              };

        packages =
          forAllSystems (system:
            forAllOcamlPackages (ocamlPackages:
              nixpkgsFor.${system}.${ocamlPackages}));

        defaultPackage =
          forAllSystems (system:
            nixpkgsFor.${system}.ocamlPackages.blip);
      };
}
