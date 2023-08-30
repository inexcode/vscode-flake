{
  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs, nix-vscode-extensions }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
          extensions = nix-vscode-extensions.extensions.${system};
          inherit (pkgs) vscode-with-extensions vscode;

          packages.default =
            vscode-with-extensions.override {
              vscodeExtensions = [
                pkgs.vscode-extensions.ms-vsliveshare.vsliveshare
                pkgs.vscode-extensions.github.copilot
                pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
                pkgs.vscode-extensions.eugleo.magic-racket

                extensions.vscode-marketplace.arcticicestudio.nord-visual-studio-code
                extensions.vscode-marketplace.bbenoist.nix
                extensions.vscode-marketplace.davidanson.vscode-markdownlint
                extensions.vscode-marketplace.dbaeumer.vscode-eslint
                extensions.vscode-marketplace.james-yu.latex-workshop
                extensions.vscode-marketplace.jnoortheen.nix-ide
                extensions.vscode-marketplace.mhutchie.git-graph
                extensions.vscode-marketplace.ms-azuretools.vscode-docker
                extensions.vscode-marketplace.ms-python.vscode-pylance
                extensions.vscode-marketplace.ms-python.python
                extensions.vscode-marketplace.ms-toolsai.jupyter
                extensions.vscode-marketplace.ms-vscode.cpptools
                extensions.vscode-marketplace.github.github-vscode-theme
                extensions.vscode-marketplace.dart-code.flutter
                extensions.vscode-marketplace.dart-code.dart-code
                extensions.vscode-marketplace.davidlday.languagetool-linter
                extensions.vscode-marketplace.eamodio.gitlens
                extensions.vscode-marketplace.ms-vscode-remote.remote-containers
                extensions.vscode-marketplace.ms-python.pylint
                extensions.vscode-marketplace.ms-python.flake8
              ];
            };

          devShells.default = pkgs.mkShell {
            buildInputs = [ packages.default ];
            shellHook = ''
              printf "VS Code with extensions:\n"
              code --list-extensions
            '';
          };
        in
        {
          inherit packages devShells;
          channels.nixpkgs.config.allowUnfree = true;
        });
}
