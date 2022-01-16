{
  description = "Packages used in DSC courses @ UCSD.";

  outputs = { self, nixpkgs }: 
  let
    supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    
  in
  {

    packages = forAllSystems (system: 
    let
      pkgs = import nixpkgs { system = "${system}"; };
    in
      {
        automata = pkgs.python3Packages.buildPythonPackage {
          name = "automata";
          src = pkgs.fetchFromGitHub {
            owner = "eldridgejm";
            repo = "automata";
            rev = "main";
            sha256 = "sha256-dTrSJRxWHcAxc2f/LgYgciu3IzcHjVjhypUkyfwtmw0=";
          };
          propagatedBuildInputs = with pkgs.python3Packages; [ 
            pyyaml
            markdown
            jinja2
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

      }

    );

  };
}
