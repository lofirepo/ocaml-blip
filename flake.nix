{
  description = "BLIP: BLoom-then-flIP";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/master;
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.ocaml-bitv =
      with import nixpkgs { system = "x86_64-linux"; };
      ocamlPackages.buildDunePackage rec {
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

    packages.x86_64-linux.ocaml-bloomf =
      with import nixpkgs { system = "x86_64-linux"; };
      ocamlPackages.buildDunePackage rec {
        pname = "bloomf";
        version = "0.2.0";
        src = fetchFromGitHub {
          owner = "mirage";
          repo = pname;
          rev = "v${version}";
          sha256 = "0jq75sr4z059kzbz0lb4rdfbcx7pq0qs8wiww1pnhkhhpnmvw1aq";
        };
        useDune2 = true;

        buildInputs = with pkgs.ocamlPackages; [
          self.packages.x86_64-linux.ocaml-bitv
        ];
      };

    packages.x86_64-linux.ocaml-blip =
      with import nixpkgs { system = "x86_64-linux"; };
      ocamlPackages.buildDunePackage rec {
        pname = "blip";
        version = "0.0.1";
        src = self;
        useDune2 = true;

        buildInputs = with pkgs.ocamlPackages; [
          self.packages.x86_64-linux.ocaml-bloomf
          self.packages.x86_64-linux.ocaml-bitv
          nocrypto
          ounit
        ];
      };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.ocaml-blip;
  };
}
