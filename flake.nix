{
  description = "Packages used in DSC courses @ UCSD.";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/23.11;

    automata-flake.url = "github:eldridgejm/automata";
    automata-flake.inputs.nixpkgs.follows = "nixpkgs";

    dsc40graph-flake.url = "github:eldridgejm/dsc40graph";
    dsc40graph-flake.inputs.nixpkgs.follows = "nixpkgs";

    gradelib-flake.url = "github:eldridgejm/gradelib";
    gradelib-flake.inputs.nixpkgs.follows = "nixpkgs";

    dsctex-flake.url = "github:eldridgejm/dsctex";
    dsctex-flake.inputs.nixpkgs.follows = "nixpkgs";

    removesoln-flake.url = "github:eldridgejm/removesoln";
    removesoln-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    automata-flake,
    dsc40graph-flake,
    gradelib-flake,
    dsctex-flake,
    removesoln-flake,
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
  in {
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {system = "${system}";};
      in rec {
        automata = automata-flake.defaultPackage."${system}";
        dsc40graph = dsc40graph-flake.defaultPackage."${system}";
        gradelib = gradelib-flake.defaultPackage."${system}";
        dsctex = dsctex-flake.defaultPackage."${system}";
        removesoln = removesoln-flake.defaultPackage."${system}";

        gradescope-utils = pkgs.python3Packages.buildPythonPackage rec {
          pname = "gradescope-utils";
          version = "0.4.0";
          name = "${pname}-${version}";
          src = builtins.fetchurl {
            url = "https://files.pythonhosted.org/packages/bf/71/d107b262e6a002f66369e42f22044f21d744353e76fd69ae3c0e47410b40/gradescope-utils-0.4.0.tar.gz";
            sha256 = "1733hb87gkr7cs9wdn8paql1jw37z3jszhr55x7yhjasvx7r293g";
          };
          propagatedBuildInputs = [pkgs.python3Packages.notebook];
        };
      }
    );
  };
}
