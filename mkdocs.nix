{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    self',
    ...
  }: let
    inherit (pkgs) stdenv mkdocs python310Packages;
    reference-doc = pkgs.callPackage ./reference.nix {inherit lib;};
  in {
    packages.docs = stdenv.mkDerivation {
      src = ./.;
      name = "ethereum-nix-docs";

      buildInput = [reference-doc];
      nativeBuildInputs = [mkdocs python310Packages.mkdocs-material];

      buildPhase = ''
        ln -s ${reference-doc} ./docs/modules/reference.md
        mkdocs build
      '';

      installPhase = ''
        mv site $out
      '';
    };

    apps.deploy-docs = let
      script = pkgs.writeShellScriptBin "deploy-docs" ''
        set -euo pipefail

        # configure git
        GIT_NAME=$(git config user.name)
        GIT_EMAIL=$(git config user.email)

        if [[ $GIT_NAME = "" ]]; then
            GIT_NAME=$GITHUB_ACTOR
            git config user.name $GIT_NAME
        fi

        if [[ $GIT_EMAIL = "" ]]; then
            GIT_EMAIL="$GIT_NAME@users.noreply.github.com"
            git config user.email $GIT_EMAIL
        fi

        GIT_REVISION=$(git rev-parse --short HEAD)

        echo "Git user: $(git config user.name)"
        echo "Git email: $(git config user.email)"
        echo "Revision: $GIT_REVISION"

        # build the docs and capture output path before we switch branches
        SITE=$(nix build --print-out-paths .#docs)

        git checkout gh-pages
        rm -rf ./*
        cp -r $SITE/* ./
        chmod -R u+w *
        git add .
        git commit -m "deploy: $GIT_REVISION"
        git push
      '';
    in {
      type = "app";
      program = "${script}/bin/deploy-docs";
    };

    mission-control.scripts = let
      category = "Docs";
    in
      with lib; {
        docs = {
          inherit category;
          description = "Serve docs";
          exec = ''
            # link in options reference
            rm -f ./docs/modules/reference.md
            ln -s ${reference-doc} ./docs/modules/reference.md

            mkdocs serve
          '';
        };
      };
  };
}
