# Dotfiles + Nix + chezmoi

This repository manages my environment with a two-layer workflow:

1. **chezmoi** stores and deploys every dotfile and performs the initial bootstrap.  
2. **Nix / Home Manager** installs all packages declared in `~/.config/home-manager/home.nix`.

---

## Quick start (on a fresh Linux machine)

```bash
# 1) Install chezmoi if it is missing
sh -c "$(curl -fsLS https://chezmoi.io/get)"

# 2) Clone this repo and apply dotfiles
chezmoi init <your-github-user>/dotfiles.nix --apply
#   ↳ runs:
#       .chezmoiscripts/run_onchange_after_01-nix-bootstrap.sh.tmpl  (install Nix + Home Manager)
#       .chezmoiscripts/run_02-ohmytmux.sh.tmpl                       (clone / update oh-my-tmux)
#       .chezmoiscripts/run_once_after_03-ohmyzsh-install.sh.tmpl     (install Oh-My-Zsh)
#       .chezmoiscripts/run_once_after_04-npm-globals.sh.tmpl         (install / upgrade npm global packages)

# 3) Reload the shell so that the nix command is available
exec $SHELL -l

# 4) Install all declared packages
home-manager switch
```

## Secrets encryption (age)

`chezmoi` keeps private files (e.g. `.envrc`) **encrypted** with
[age](https://github.com/FiloSottile/age).  
Set up the key once on every new machine **before** running  
`chezmoi init --apply` so secrets can be decrypted:

```bash
# 1) generate or copy an age key
mkdir -p ~/.config/chezmoi/age
age-keygen -o ~/.config/chezmoi/age/keys.txt

# 2) tell chezmoi to use age and your public key
cat > ~/.config/chezmoi/chezmoi.yaml <<'EOF'
encryption: "age"

age:
  identities:
    - "{{ .chezmoi.homeDir }}/.config/chezmoi/age/keys.txt"
  recipients:
    # replace with *your* age public key (output of `age-keygen -p`)
    - age1YOURPUBLICKEYXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
EOF
```

Working with encrypted files:

```bash
# add a new secret
chezmoi add --encrypt ~/.envrc

# edit an existing secret
chezmoi edit --apply ~/.envrc
```

---

## Repository layout

```
.chezmoiscripts/
├── run_onchange_after_01-nix-bootstrap.sh.tmpl   # install Nix + Home Manager
├── run_02-ohmytmux.sh.tmpl                       # clone / update oh-my-tmux
├── run_once_after_03-ohmyzsh-install.sh.tmpl     # unattended OMZ install
└── run_once_after_04-npm-globals.sh.tmpl         # install / update npm globals

dot_config/
├── home-manager/
│   └── home.nix                                  # package list (Home Manager)
└── nvim/                                   # example program config
    ├── init.lua
    └── lua/…

dot_tmux.conf.local.tmpl                    # personal tmux overrides
```

---

## Day-to-day workflow

| Task                       | Command                                             |
|----------------------------|-----------------------------------------------------|
| Edit / add dotfiles or update oh-my-tmux | modify files → `chezmoi apply` (also pulls latest oh-my-tmux) |
| Install / update packages  | `home-manager switch`                               |
| Update channels & packages | `nix-channel --update && home-manager switch` |
  (works the same; line retained for clarity)

`run_onchange_*` scripts execute only when their file content changes, so
`chezmoi apply` does **not** reinstall or update Nix every time.
