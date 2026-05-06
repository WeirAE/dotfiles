# dotfiles

Personal and HPC work environment configuration, managed with Ansible.

## Repository layout
```
dotfiles/
├── personal/
│   ├── zsh/          .zshrc, .zprofile
│   ├── git/          .gitconfig, global ignore
│   └── nvim/         init.lua + lua/custom/ (NvChad overrides)
├── hpc/
│   ├── bash/         .bashrc, .bash_profile
│   ├── vim/          .vimrc (no-plugin, offline-safe)
│   └── git/          .gitconfig, global ignore
└── ansible/
    ├── site.yml               entry point
    ├── inventory/hosts.yml    machine inventory
    ├── group_vars/
    │   ├── personal.yml       package lists, URLs, paths
    │   └── hpc.yml
    └── roles/
        ├── personal/tasks/    xdg, packages, uv, shell, git, neovim, delta
        └── hpc/tasks/         dirs, packages, userspace_tools, shell, git, vim
```
