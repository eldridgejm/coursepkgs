{
  description = "Packages used in DSC courses @ UCSD.";

  outputs = { self, nixpkgs }: 
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

        automata = pkgs.python3Packages.buildPythonPackage {
          name = "automata";
          src = pkgs.fetchFromGitHub {
            owner = "eldridgejm";
            repo = "automata";
            rev = "8766ca9076b5280d410bd23703cbc82898bd3a2c";
            sha256 = "sha256-dTrSJRxWHcAxc2f/LgYgciu3IzcHjVjhypUkyfwtmw0=";
          };
          propagatedBuildInputs = with pkgs.python3Packages; [ 
            pyyaml
            markdown
            jinja2
            dictconfig
          ];
          nativeBuildInputs = with pkgs.python3Packages; [ pytest black ipython sphinx sphinx_rtd_theme lxml ];
          doCheck = false;
        };

        dsc40graph = pkgs.python3Packages.buildPythonPackage {
          name = "dsc40graph";
          src = pkgs.fetchFromGitHub {
            owner = "eldridgejm";
            repo = "dsc40graph";
            rev = "master";
            sha256 = "sha256-xlUdwukDmZdke0oP+HTkWptx0P9KRkKAcxkHrprrb3A=";
          };
          nativeBuildInputs = with pkgs.python3.pkgs; [ pytest black ipython jupyter ];
        };

        dscproblemset = pkgs.stdenv.mkDerivation rec {
          name = "dscproblemset.sty";
          src = pkgs.fetchFromGitHub {
            owner = "eldridgejm";
            repo = "dscproblemset.sty";
            rev = "main";
            sha256 = "sha256-OMaQgW3CVGGVXqUZEgLbGHstvFOVxUR9Hs/ao85xusk=";
          };
          installPhase = ''
          mkdir -p $out
          cp dscproblemset.sty $out/
          '';
          pname = name;
          tlType = "run";
        };

        dscslides = pkgs.stdenv.mkDerivation rec {
          name = "dscslides.cls";
          src = pkgs.fetchFromGitHub {
            owner = "eldridgejm";
            repo = "dscslides.cls";
            rev = "main";
            sha256 = "sha256-NQBF1LnyHzQPeShkYSNL99gCkekZZkw5/oYcZ2g/6cs=";
          };
          installPhase = ''
          mkdir -p $out
          cp dscslides.cls $out/
          '';
          pname = name;
          tlType = "run";
        };

        dictconfig = pkgs.python3Packages.buildPythonPackage {
          name = "dictconfig";
          src = pkgs.fetchFromGitHub {
            owner = "eldridgejm";
            repo = "dictconfig";
            rev = "3db0e7edda59a162d64c9a7ac441e1c5bf848eda";
            sha256 = "sha256-1PrVTiClDV2vohxiAa3DRcmSFw7I9WCQn2ZsDiV5Om8=";
          };
          propagatedBuildInputs = with pkgs.python3Packages; [ jinja2 ];
          nativeBuildInputs = with pkgs.python3Packages; [ pytest black ipython sphinx sphinx_rtd_theme ];
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

        gradelib = pkgs.python3.pkgs.buildPythonPackage rec {
          name = "gradelib";
          src = pkgs.fetchFromGitHub {
            owner = "eldridgejm";
            repo = "gradelib";
            rev = "master";
            sha256 = "sha256-Ya6+awGwYrbDt0d/oj51wF40hK2gn850cYo+2slcLEk=";
          };
          propagatedBuildInputs = with pkgs.python3.pkgs; [ pandas matplotlib numpy ];
          nativeBuildInputs = with pkgs.python3.pkgs; [ black pytest ipython sphinx sphinx_rtd_theme ];
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
