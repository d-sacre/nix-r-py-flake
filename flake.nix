
#
{
  description = "R/Python Development Flake";

  outputs = { self, nixpkgs }: {
    devShell.x86_64-linux =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # sets/limits??? (indirectly) the Development System to x86_64-linux
        custom-r-version = pkgs.rPackages.overrideAttrs{
          version = "4.3.1";
        };
        rpkgs = builtins.attrValues {
          inherit (custom-r-version) forecast lubridate tidyr stringr forcats testthat ggplot2 plotly gridExtra naniar yaml glue caret prophet readxl feather tidyverse shiny;
        };
        systemPackages = builtins.attrValues {
          inherit (pkgs) R glibcLocales nix ;
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

