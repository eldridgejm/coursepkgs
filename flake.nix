{
  description = "Packages used in DSC courses @ UCSD.";

  outputs = { self, nixpkgs }: 
  let
    supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
  in
  {

    packages = forAllSystems (system: 
    {

      dsc40graph = (
        with import nixpkgs { system = "${system}"; };
        python3Packages.buildPythonPackage {
          name = "dsc40graph";
          src = fetchFromGitHub {
            owner = "eldridgejm";
            repo = "dsc40graph";
            rev = "master";
            sha256 = "sha256-xlUdwukDmZdke0oP+HTkWptx0P9KRkKAcxkHrprrb3A=";
          };
          propagatedBuildInputs = with python3Packages; [];
          nativeBuildInputs = with python3Packages; [ pytest black ipython jupyter ];
        }
      );

    }

    );

  };
}
