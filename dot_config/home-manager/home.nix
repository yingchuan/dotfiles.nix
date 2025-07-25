{ config, pkgs, lib, ... }:

let
  username = builtins.getEnv "USER";
  homedir  = builtins.getEnv "HOME";
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username      = lib.mkDefault username;
  home.homeDirectory = lib.mkDefault homedir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Disable Home-Manager vs Nixpkgs release-mismatch warning
  home.enableNixpkgsReleaseCheck = false;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    neovim
    fcitx5
    fcitx5-chinese-addons
    fcitx5-chewing
    tree-sitter              # CLI needed by nvim-treesitter to compile parsers
    tree-sitter-grammars.tree-sitter-llvm  # LLVM grammar for tree-sitter
    fzf                      # fuzzy-finder backend for OMZ + Telescope
    ripgrep                  # live-grep provider
    bat                      # modern cat(1) clone with syntax highlighting
    fd                       # fast file search used by Telescope/Snacks
    tree                     # recursive directory listing utility
    zsh                      # shell
    tmux                     # terminal multiplexer
    lua5_1                   # Lua 5.1 interpreter
    (lua51Packages.luarocks) # LuaRocks package manager built for 5.1
    clang                    # LLVM / Clang tool-chain (clang, clang++)
    clang-tools              # provides clang-format, clang-tidy, clangd, …
    cmake                    # cross-platform build system generator
    zlib                     # compression library
    ncurses                  # terminal control library (provides tinfo)
    libxml2                  # XML parsing library
    autoconf                 # GNU autoconf for generating configure scripts
    nodejs                   # JavaScript/TypeScript runtime (includes npm)

    # ── additional language stacks ───────────────────────────────
    rustc        # Rust compiler
    cargo        # Rust package manager / build tool
    go           # Go tool-chain
    php          # PHP interpreter (current stable, 8.x)
    (phpPackages.composer)  # PHP package manager
    openjdk      # Java Development Kit
    (python3.withPackages (ps: with ps; [ 
      pip 
      pynvim 
      jupyter 
      matplotlib 
      pandas 
      numpy 
      ipywidgets 
    ]))  # Python 3 + pip + pynvim + data science packages
    zig          # Zig compiler + build system
    gdb          # GNU debugger, needed by nvim-dap cppdbg adapter
    viu          # terminal image viewer (Sixel/Kitty/iterm2)
    chafa        # ANSI/Unicode graphics converter
    ueberzugpp   # image preview helper used by e.g. neovim-image.nvim
    lazygit      # TUI Git client
    htop         # interactive process viewer
    unzip        # ZIP extraction utility
    direnv       # automatic per-directory environment loader
    uv                  # Rust-based Python package manager
    ruff                # Python linter / formatter
    pre-commit          # hook runner

    # ── clipboard helpers for Neovim ─────────────────────────────
    wl-clipboard  # Wayland clipboard (wl-copy / wl-paste)
    age          # modern file-encryption tool (used by chezmoi for secrets)
    rbw          # Rust-based Bitwarden CLI (sync + unlock)
    aichat                       # AI-powered chat in terminal


    # ── language runtimes & managers ────────────────────────────
    ruby         # Ruby interpreter
    julia-bin    # Julia (binary distribution, avoids long compile)
    pipx         # Isolated Python application installer

    # ── document / graphics tool-chain ──────────────────────────
    imagemagick  # 'magick' / 'convert' CLI
    ghostscript  # 'gs' PDF/PostScript utilities
    tectonic     # Modern LaTeX engine
    typst        # Typst typesetting system
    texliveSmall # provides pdflatex, detex, and basic TeX tools

    # ── diagram generation ──────────────────────────────────────


    # ── database tools ──────────────────────────────────────────
    sqlite              # shared library libsqlite3.so (needed by Snacks)
    sqlite-interactive  # sqlite3 CLI shell
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ubuntu/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE  = "fcitx5";
    XMODIFIERS    = "@im=fcitx5";
    INPUT_METHOD  = "fcitx5";
  };

  # Expose binaries installed by the Chezmoiscript's npm prefix ($HOME/.local)
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Enable direnv + nix-direnv hook
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Let Home Manager install and manage itself.

  programs.home-manager.enable = true;

  programs.keychain = {
    enable = true;               # enable keychain
    enableBashIntegration = true; # auto-start keychain for Bash
    enableZshIntegration  = true; # auto-start keychain for Zsh
    # uncomment the next line to start only ssh-agent:
    # extraFlags = [ "--agents" "ssh" ];
  };

  systemd.user.services.fcitx5 = {
    Unit = { Description = "Fcitx5 input-method daemon"; };
    Service = {
      ExecStart = "${pkgs.fcitx5}/bin/fcitx5 -d";
      Restart   = "on-failure";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };

  # ── Input-method ─────────────────────────────────────────────
}
