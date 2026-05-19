# macOS Dev Setup

## Overview

This repo now splits app installation into three sources under [`setup/apps`](apps):

- [`homebrew.txt`](apps/homebrew.txt): `brew bundle` formulae and casks
- [`mas.txt`](apps/mas.txt): Mac App Store apps installed with `mas`
- [`dmg.txt`](apps/dmg.txt): apps that need manual download / install

The main entrypoint is [`install.sh`](install.sh). It runs in this order:

1. Install Homebrew packages and casks from `setup/apps/homebrew.txt`
2. Install Mac App Store apps from `setup/apps/mas.txt`
3. Check `setup/apps/dmg.txt` and print the remaining manual download items

## Quick Start

Prerequisites:

- Install Homebrew first if `brew` is not available:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- Sign in to the Mac App Store app if you want `mas` installs to succeed

Run:

```bash
bash setup/install.sh
```

## App Sources

### Homebrew

Managed by [`homebrew.txt`](apps/homebrew.txt).

Manual command:

```bash
brew bundle --file=setup/apps/homebrew.txt
```

### Mac App Store

Managed by [`mas.txt`](apps/mas.txt).

Manual commands:

```bash
mas install $(awk '/^[0-9]+/{print $1}' setup/apps/mas.txt)
mas install --force $(awk '/^[0-9]+/{print $1}' setup/apps/mas.txt)
```

Notes:

- `mas` itself is installed from Homebrew
- The app must be available in your App Store region/account
- Some apps may require prior purchase or prior “Get” history

### Manual DMG / ZIP / PKG

Managed by [`dmg.txt`](apps/dmg.txt).

The installer does not auto-download these apps. It only checks whether they are already installed and prints the pending items with:

- source type
- homepage / repo
- download URL
- notes

Use this list for apps that:

- are no longer suitable for Homebrew
- are deprecated / disabled in Homebrew cask
- are intentionally kept as direct downloads

The [`install.sh`](install.sh) script does not auto-download these apps. It only prints what is still missing after checking `/Applications` and your shell `PATH`.
The current [`dmg.txt`](apps/dmg.txt) is a curated direct-download list, so it no longer keeps a separate `Needs Research` section.

## Recommended Flow On a New Mac

1. Install Homebrew
2. Open the App Store app and sign in
3. Run:

```bash
bash setup/install.sh
```

4. Review the printed manual download items from `setup/apps/dmg.txt`
5. Install the remaining manual apps one by one
6. Re-stow dotfiles with `bash setup/restow.sh`

## Manual Download Workflow

Use [`dmg.txt`](apps/dmg.txt) as the manual recovery checklist.

Typical manual install flow:

1. Open the listed repo or homepage
2. Download the archive from the listed URL
3. Move the app into `/Applications` or install the `.pkg`
4. Re-run `bash setup/install.sh` to see what is still missing

## Restow Examples

Re-stow everything:

```bash
bash setup/restow.sh
```

Re-stow a few packages only:

```bash
bash setup/restow.sh zsh tmux nvim codex
```

## Stow

After packages and apps are ready, re-stow dotfiles as needed:

```bash
bash setup/restow.sh
```

Dry run:

```bash
bash setup/restow.sh --dry-run
```

## Post-Install Checklist

- `brew` works and `brew bundle --file=setup/apps/homebrew.txt` is clean
- `mas` works and App Store apps install successfully
- manual app list in `setup/apps/dmg.txt` is reviewed
- `bash setup/restow.sh` finishes without errors
- shell, tmux, codex, and editor configs load correctly
- any missing private apps or region-limited apps are installed manually

## Notes

- `setup/install.sh` is only responsible for app/package bootstrap
- `setup/restow.sh` is responsible for symlinking dotfiles
- `setup/sync.sh` is for local sync / commit workflow, not initial setup
