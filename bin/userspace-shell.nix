{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.antibody
    pkgs.bat
    pkgs.chezmoi
    pkgs.diff-so-fancy
    pkgs.dog
    pkgs.entr
    pkgs.exa
    pkgs.fd
    pkgs.file
    pkgs.fzf
    pkgs.htop
    pkgs.httpie
    pkgs.hyperfine
    pkgs.jq
    pkgs.lazygit
    pkgs.neovim
    pkgs.nodePackages.npm
    pkgs.nodejs
    pkgs.parallel
    pkgs.shellcheck
    pkgs.silver-searcher
    pkgs.tealdeer
    pkgs.tmux
    pkgs.wget
    pkgs.zsh
  ];

  shellHook = ''
    export SHELL=$(which zsh)
    zsh
  '';
}
