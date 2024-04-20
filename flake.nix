
#
{
  description = "R/Python Development Flake";

  outputs = { self, nixpkgs }: {
    devShell.x86_64-linux =
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system}; # sets/limits??? (indirectly) the Development System to x86_64-linux
        custom-r-version = import nixpkgs { 
          inherit system; 
          overlays = [ 
            final: prev:
            {
              rPackages = prev.rPackages.override {
                overrides = {
                  version = "4.3.1";
                };
              };
            }
          ]; 
        };
        rpkgs = builtins.attrValues {
          inherit (custom-r-version) forecast lubridate tidyr stringr forcats testthat ggplot2 plotly gridExtra naniar yaml glue caret prophet readxl feather tidyverse shiny;
        };
        systemPackages = builtins.attrValues {
          inherit (custom-r-version) R glibcLocales nix ;
        };
      in pkgs.mkShell {
        nativeBuildInputs = [ # for the system the Developement Environment is running on!
          rpkgs
          systemPackages
          pkgs.rstudio
        ];
      };
  };
}

