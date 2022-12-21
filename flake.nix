{
  description = "Packages used in DSC courses @ UCSD.";

  inputs = {

    nixpkgs.url = github:NixOS/nixpkgs/21.11;

    automata-flake.url = "github:eldridgejm/automata";
    automata-flake.inputs.nixpkgs.follows = "nixpkgs";

    dsc40graph-flake.url = "github:eldridgejm/dsc40graph";
    dsc40graph-flake.inputs.nixpkgs.follows = "nixpkgs";

    gradelib-flake.url = "github:eldridgejm/gradelib";
    gradelib-flake.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, automata-flake, dsc40graph-flake, gradelib-flake }: 
  let
    supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

  in
  {
    packages = forAllSystems (system: 
    let
      pkgs = import nixpkgs { system = "${system}"; };
    in
      rec {

        automata = automata-flake.defaultPackage."${system}";
        dsc40graph = dsc40graph-flake.defaultPackage."${system}";
        gradelib = gradelib-flake.defaultPackage."${system}";

        dsctex = pkgs.stdenv.mkDerivation rec {
          name = "dsctex";
          src = pkgs.fetchFromGitHub {
            owner = "eldridgejm";
            repo = "dsctex";
            rev = "main";
            sha256 = "sha256-6vn52U6CIrFTNwLG5fLQqOFs85o0vkXTcdGMWz/34Fc=";
          };
          installPhase = ''
          mkdir -p $out
          cp * $out/
          '';
          pname = name;
          tlType = "run";
        };

        gradescope-utils = pkgs.python3Packages.buildPythonPackage rec {
          pname = "gradescope-utils";
          version = "0.4.0";
          name = "${pname}-${version}";
          src = builtins.fetchurl {
            url = "https://files.pythonhosted.org/packages/bf/71/d107b262e6a002f66369e42f22044f21d744353e76fd69ae3c0e47410b40/gradescope-utils-0.4.0.tar.gz";
            sha256 = "1733hb87gkr7cs9wdn8paql1jw37z3jszhr55x7yhjasvx7r293g";
          };
          propagatedBuildInputs = [ pkgs.python3Packages.notebook ];
        };

        removesoln =
          let
            texsoup = pkgs.python3Packages.buildPythonPackage rec {
              pname = "texsoup";
              version = "0.3.1";
              name = "${pname}-${version}";
              src = builtins.fetchurl {
                url = "https://files.pythonhosted.org/packages/84/58/1c503390ed1a81cdcbff811dbf7a54132994acef8dd2194d55cf657a9e97/TexSoup-0.3.1.tar.gz";
                sha256 = "02xpvmhy174z6svpghzq4gs2bsyh0jxc2i7mark8ls73mg82lsrz";
              };
              doCheck = false;
            };
          in
            pkgs.python3Packages.buildPythonPackage rec {
              name = "removesoln";
              src = pkgs.fetchFromGitHub {
                owner = "eldridgejm";
                repo = "removesoln";
                rev = "02ce3d9a4d1a7bd9e76182ff796aea4d2d2ddb35";
                sha256 = "sha256-EIVhIhfp9xsQIZNDEJcUnlW2bGTZYi4gJQLF/lFGaUs=";
              };
              propagatedBuildInputs = [ texsoup ];
            };

      }
    );

  };
}
