
#
{
  description = "R/Python Development Flake";

  outputs = { self, nixpkgs }: {

    devShell.x86_64-linux =
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system}; # sets/limits??? (indirectly) the Development System to x86_64-linux
        rpkgs = builtins.attrValues {
          inherit (pkgs.rPackages) forecast lubridate tidyr stringr forcats testthat ggplot2 plotly gridExtra naniar yaml glue caret prophet readxl feather tidyverse shiny;
        };
        systemPackages = builtins.attrValues {
          inherit (pkgs) R glibcLocales nix ;
        };

      in pkgs.mkShell {
        nativeBuildInputs = [ # for the system the Developement Environment is running on!
          rpkgs
          systemPackages
        ];
      };
  };
}

