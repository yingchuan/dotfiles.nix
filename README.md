# Dotfiles + Nix + chezmoi

This repository manages my environment with a two-layer workflow:

1. **chezmoi** stores and deploys every dotfile and performs the initial bootstrap.  
2. **Nix / Home Manager** installs all packages declared in `~/.config/nixpkgs/home.nix`.

---

## Quick start (on a fresh Linux machine)

```bash
# 1) Install chezmoi if it is missing
sh -c "$(curl -fsLS https://chezmoi.io/get)"

# 2) Clone this repo and apply dotfiles
chezmoi init <your-github-user>/dotfiles.nix --apply
#   ↳ runs .chezmoiscripts/run_onchange_01-nix-bootstrap.sh.tmpl
#     which installs Nix, enables flakes and sets up Home Manager.

# 3) Reload the shell so that the nix command is available
exec $SHELL -l

# 4) Install all declared packages
home-manager switch
```

---

## Repository layout

```
.chezmoiscripts/
└── run_onchange_01-nix-bootstrap.sh.tmpl   # install Nix + Home Manager

dot_config/
├── nixpkgs/
│   └── home.nix.tmpl                       # package list (Home Manager)
└── nvim/                                   # example program config
    ├── init.lua
    └── lua/…
```

---

## Day-to-day workflow

| Task                       | Command                                             |
|----------------------------|-----------------------------------------------------|
| Edit / add dotfiles        | modify files → `chezmoi apply`                      |
| Install / update packages  | `home-manager switch`                               |
| Update channels & packages | `nix-channel --update && home-manager switch`       |

`run_onchange_*` scripts execute only when their file content changes, so
`chezmoi apply` does **not** reinstall or update Nix every time.
