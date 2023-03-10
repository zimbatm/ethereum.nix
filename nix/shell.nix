{
  perSystem = {
    lib,
    pkgs,
    config,
    inputs',
    ...
  }: let
    inherit (config.mission-control) installToDevShell;
    inherit (pkgs) mkShellNoCC;
    inherit (inputs'.nixpkgs-unstable.legacyPackages) nix-update;
  in {
    devShells.default = installToDevShell (mkShellNoCC {
      name = "ethereum.nix";
      packages = [
        pkgs.statix
        pkgs.mkdocs
        pkgs.python310Packages.mkdocs-material
        nix-update
      ];
    });
  };
}
