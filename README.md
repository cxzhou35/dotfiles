# Zicx's Dotfiles

This is the home of all my dotfiles. These are files that add custom configurations to my computer(macOS) and applications, primarily the terminal.

## Table of Contents

<details>
  <summary>
    <small><i>(🔎 Click to expand/collapse)</i></small>
  </summary>

<!--toc:start-->
- [Table of Contents](#table-of-contents)
- [Setup](#setup)
- [Software](#software)
<!--toc:end-->

</details>

## Setup

My dotfiles are managed by [GNU Stow](https://www.gnu.org/software/stow/).

1. Install [Homebrew](https://brew.sh/)
2. Install [GNU Stow](https://www.gnu.org/software/stow/) (`brew install stow`)
3. Clone this repository

```sh
# modify the path as you like
mkdir -p ~/Github
git clone https://github.com/cxzhou35/dotfiles.git ~/Github/dotfiles
```

4. Run the following script

```sh
bash setup/install.sh
```

## Software

- Terminal:
    - [iterm2](./iterm2/)
    - [alacritty](./alacritty/)
    - [wezterm](./wezterm/)
    - [kitty](./kitty/)
- Shell: [zsh](./zsh/)
- Shell prompt: [starship](./starship/)
- macOS package manager: [homebrew](./brew/)
- Multiplexer: [tmux](./tmux/)
    - Session manager: [sesh](./sesh/)
- System info: [fastfetch](./fastfetch/)
- Editor:
    - [neovim](./nvim)
    - [vscode](./vscode/)
- Git: [lazygit](./lazygit/)
- Terminal file manager: [yazi](./yazi/)
- Terminal system monitor: [btop](./btop/)
- Self-defined binary files: [bin](./bin/)

## TODO

- [ x ] Fix GitHub Copilot setup error in neovim.
- [ ] Write a brief introduction of my daily workflow.

## Acknowledgement

<details>
<summary>Thanks for these great public dotfiles 💫</summary>

- [omerxx/dotfiles](https://github.com/omerxx/dotfiles)
- [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public)
- [joshmedeski/dotfiles](https://github.com/joshmedeski/dotfiles)
- [JazzyGrim/dotfiles](https://github.com/JazzyGrim/dotfiles)
- [josean-dev/dev-environment-files](https://github.com/josean-dev/dev-environment-files)
- [jellydn/lazy-nvim-ide](https://github.com/jellydn/lazy-nvim-ide)
- [Kicamon/nvim](https://github.com/Kicamon/nvim)
- [killua9910/dotfiles](https://github.com/killua9910/dotfiles)
- [ayamir/nvimdots](https://github.com/ayamir/nvimdots)
- [chrisgrieser/.config](https://github.com/chrisgrieser/.config)
- [Matt-FTW/dotfiles](https://github.com/Matt-FTW/dotfiles)

</details>
